require 'spec_helper'

describe YieldStarClient do
  let(:default_endpoint) { YieldStarClient::DEFAULT_ENDPOINT }
  let(:default_namespace) { YieldStarClient::DEFAULT_NAMESPACE }

  let(:endpoint) { 'http://configured.endpoint.com' }
  let(:username) { 'configured user' }
  let(:password) { 'configured password' }
  let(:namespace) { 'http://configured.namespace.com' }
  let(:client_name) { 'configured client name' }

  after { YieldStarClient.reset }

  it "should have a version" do
    subject::VERSION.should be
  end

  context "with default configuration" do
    it "has the correct settings" do
      expect(subject.endpoint).to eq default_endpoint
      expect(subject.username).to be_blank
      expect(subject.password).to be_blank
      expect(subject.namespace).to eq default_namespace
      expect(subject.client_name).to be_blank
      expect(subject.logger).to be_an_instance_of Logger
      expect(subject).to_not be_debug
    end
  end

  describe ".configure" do
    subject { YieldStarClient.configure(&config_block) }

    let(:logger) { mock() }

    context "with full configuration" do
      let(:config_block) do
        lambda do |config|
          config.endpoint = endpoint
          config.username = username
          config.password = password
          config.namespace = namespace
          config.client_name = client_name
          config.debug = true
          config.logger = logger
        end
      end

      it { should == YieldStarClient }

      it "has the correct configuration" do
        expect(subject.endpoint).to eq endpoint
        expect(subject.username).to eq username
        expect(subject.password).to eq password
        expect(subject.namespace).to eq namespace
        expect(subject.client_name).to eq client_name
        expect(subject.logger).to eq logger
      end

      it { should be_debug }
    end

    context "with partial configuration" do
      let(:config_block) do
        lambda do |config|
          config.username = username
          config.password = password
          config.client_name = client_name
          config.debug = true
        end
      end

      it { should == YieldStarClient }

      it "has the correct configuration" do
        expect(subject.endpoint).to eq default_endpoint
        expect(subject.username).to eq username
        expect(subject.password).to eq password
        expect(subject.namespace).to eq default_namespace
        expect(subject.client_name).to eq client_name
        expect(subject.logger).to be_an_instance_of Logger
      end

      it { should be_debug }
    end
  end

  describe ".reset" do
    before do
      YieldStarClient.configure do |config|
        config.endpoint = endpoint
        config.username = username
        config.password = password
        config.namespace = namespace
        config.client_name = client_name
        config.debug = true
        config.logger = logger
      end
    end

    let(:logger) { mock() }

    subject { YieldStarClient.reset }

    it "should change the endpoint to the default" do
      expect { subject }.to change{YieldStarClient.endpoint}.from(endpoint).to(default_endpoint)
    end

    it "should clear the username" do
      expect { subject }.to change{YieldStarClient.username}.from(username).to(nil)
    end

    it "should clear the password" do
      expect { subject }.to change{YieldStarClient.password}.from(password).to(nil)
    end

    it "should clear the client_name" do
      expect { subject }.to change{YieldStarClient.client_name}.from(client_name).to(nil)
    end

    it "should change the namespace to the default" do
      expect { subject }.to change{YieldStarClient.namespace}.from(namespace).to(default_namespace)
    end

    it "should change the logger to the default" do
      expect { subject }.to change{YieldStarClient.logger}
      YieldStarClient.logger.should be_an_instance_of Logger
    end

    it "should change the debug setting to the default" do
      expect { subject }.to change{YieldStarClient.debug?}.from(true).to(false)
    end
  end
end
