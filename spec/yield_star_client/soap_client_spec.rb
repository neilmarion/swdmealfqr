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
    end

  end
end
