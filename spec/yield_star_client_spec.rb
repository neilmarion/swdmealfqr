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
    its(:endpoint) { should == default_endpoint }
    its(:username) { should_not be }
    its(:password) { should_not be }
    its(:namespace) { should == default_namespace }
    its(:client_name) { should_not be }
    its(:logger) { should be_an_instance_of Logger }
    it { should_not be_debug }
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
      its(:endpoint) { should == endpoint }
      its(:username) { should == username }
      its(:password) { should == password }
      its(:namespace) { should == namespace }
      its(:client_name) { should == client_name }
      it { should be_debug }
      its(:logger) { should == logger }
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
      its(:endpoint) { should == default_endpoint }
      its(:username) { should == username }
      its(:password) { should == password }
      its(:namespace) { should == default_namespace }
      its(:client_name) { should == client_name }
      its(:logger) { should be_an_instance_of Logger }
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
