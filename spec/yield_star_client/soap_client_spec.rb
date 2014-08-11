require "spec_helper"

module YieldStarClient
  describe SoapClient do

    describe ".request" do
      let(:savon_client) { double(::Savon::Client) }
      let(:soap_response) { double }
      let(:logger) { double }
      let(:endpoint) { "http://endpoint.com" }
      let(:namespace) { "http://endpoint.com/v1" }
      let(:action) { :some_soap_action }

      let(:params) do
        {
          client_name: "client_name",
          username: "asd",
          password: "123",
          endpoint: endpoint,
          namespace: namespace,
          log: true,
          logger: logger,
          other: "opt",
          another: "param",
        }
      end

      it "executes the action" do
        expect(::Savon).to receive(:client).with(
          element_form_default: :qualified,
          endpoint: endpoint,
          namespace: namespace,
          basic_auth: ["asd", "123"],
          log: true,
          logger: logger,
        ).and_return(savon_client)

        savon_message = {
          client_name: "client_name",
          other: "opt",
          another: "param",
        }
        expect(savon_client).to receive(:call).with(
          action,
          message: { request: savon_message }
        ).and_return(soap_response)

        expect(described_class.request(action, params)).to eq soap_response
      end

      context "a Savon::SOAPFault exception occurs" do
        let(:savon_error) do
          generic_fault = File.read("spec/fixtures/faults/generic_fault.xml")
          http = HTTPI::Response.new(500, {}, generic_fault)
          nori = Nori.new
          Savon::SOAPFault.new(http, nori)
        end

        it "re-raises the translated error" do
          action = :some_action
          params = {}

          expect(::Savon).to receive(:client).and_return(savon_client)

          allow(savon_client).to receive(:call).and_raise(savon_error)

          expected_error = StandardError.new
          expect(ServerError).to receive(:translate_fault).
            with(savon_error).
            and_return(expected_error)

          expect{ described_class.request(action, params) }.
            to raise_error(expected_error)
        end
      end
    end

  end
end
