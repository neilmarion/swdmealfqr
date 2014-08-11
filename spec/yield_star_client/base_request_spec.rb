require "spec_helper"

module YieldStarClient
  describe BaseRequest do

    context "attributes" do
      subject { described_class }

      it { is_expected.to have_attribute(:client_name, String) }
      it { is_expected.to have_attribute(:endpoint, String) }
      it { is_expected.to have_attribute(:namespace, String) }
      it { is_expected.to have_attribute(:username, String) }
      it { is_expected.to have_attribute(:password, String) }
      it { is_expected.to have_attribute(:logger) }
      it { is_expected.to have_attribute(:log) }
    end

    context "validations" do
      subject { described_class.new }

      it { is_expected.to validate_presence_of(:client_name) }
      it { is_expected.to validate_presence_of(:endpoint) }
      it { is_expected.to validate_presence_of(:namespace) }
      it { is_expected.to validate_presence_of(:username) }
      it { is_expected.to validate_presence_of(:password) }

      it { is_expected.to ensure_length_of(:client_name).is_at_most(16) }
    end

    it "validates the length of client_name" do
      request = described_class.new(client_name: "c"*17)
      expect(request).to be_invalid
    end

    describe "#request_args" do
      it "removes any keys with nil values" do
        request = described_class.new(client_name: nil, username: "Ok")
        expect(request.request_args).to eq(username: "Ok")
      end
    end

    describe ".execute" do
      context "attributes are invalid" do
        it "raises ValidationError" do
          params = {
            client_name: "very long client name",
            endpoint: "endpoint",
            namespace: "namespace",
            username: "username",
            password: "password",
          }

          request = described_class.new(params)

          expect { request.execute }.
            to raise_error(ArgumentError, "Client name is too long (maximum is 16 characters)")
        end

      end

      it "makes a request with the correct action" do
        FakeRequest = Class.new(BaseRequest)
        FakeRequest::SOAP_ACTION = :fake_action

        params = {
          client_name: "client_name",
          endpoint: "endpoint",
          namespace: "namespace",
          username: "username",
          password: "password",
        }

        response = double

        expect(SoapClient).to receive(:request).
          with(:fake_action, hash_including(params)).
          and_return(response)

        expect(FakeRequest.execute(params)).to eq response
      end
    end

  end
end
