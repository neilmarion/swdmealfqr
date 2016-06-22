require 'spec_helper'

describe YieldStarClient::Client do
  subject { client }

  after { YieldStarClient.reset }

  let(:client) do
    YieldStarClient::Client.new({:endpoint => endpoint,
                                 :username => username,
                                 :password => password,
                                 :namespace => namespace,
                                 :client_name => client_name,
                                 :debug => debug,
                                 :logger => logger})
  end

  let(:endpoint) { 'https://foo.com?wsdl' }
  let(:default_endpoint) { YieldStarClient::DEFAULT_ENDPOINT }
  let(:username) { 'test_user' }
  let(:password) { 'secret' }
  let(:namespace) { 'http://foo.com/namespace' }
  let(:client_name) { 'test_client' }
  let(:debug) { true }
  let(:logger) { double() }

  it "has the correct settings" do
    expect(subject.endpoint).to eq endpoint
    expect(subject.username).to eq username
    expect(subject.password).to eq password
    expect(subject.namespace).to eq namespace
    expect(subject.client_name).to eq client_name
    expect(subject.debug).to eq debug
  end

  it { should be_debug }

  # Methods from the PropertyMethods mixin
  # The actual tests for these are in property_methods_spec
  # TODO: test mixins using shared example groups?
  # see: http://blog.davidchelimsky.net/2010/11/07/specifying-mixins-with-shared-example-groups-in-rspec-2/
  it { should respond_to(:get_properties) }
  it { should respond_to(:get_property) }
  it { should respond_to(:get_property_parameters) }

  # Methods from the FloorPlanMethods mixin
  it { should respond_to(:get_floor_plan) }
  it { should respond_to(:get_floor_plans) }

  # Methods from UnitMethods
  it { should respond_to(:get_unit) }
  it { should respond_to(:get_units) }

  # Methods from AmenityMethods
  it { should respond_to(:get_floor_plan_amenities) }
  it { should respond_to(:get_unit_amenities) }

  # Methods from RentMethods
  it { should respond_to(:get_rent_summary) }

  # Methods from LeaseTermRentMethods
  it { should respond_to(:get_lease_term_rent) }
  it { should respond_to(:get_lease_term_rent_plus) }
  it { should respond_to(:get_renewal_lease_term_rent) }

  context "with default configuration" do
    subject(:client) { YieldStarClient::Client.new }

    it "has the correct settings" do
      expect(client.endpoint).to eq default_endpoint
      expect(client.username).to be_blank
      expect(client.password).to be_blank
      expect(client.namespace).to eq YieldStarClient::DEFAULT_NAMESPACE
      expect(client.client_name).to be_blank
      expect(client.logger).to be_a Logger
    end

    it { should_not be_debug }
  end

  describe "#endpoint=" do
    subject { client.endpoint = new_endpoint }

    context "with a new endpoint" do
      let(:new_endpoint) { 'http://new-foo.com/service/' }

      it "should change the endpoint" do
        expect { subject }.to change{client.endpoint}.from(endpoint).to(new_endpoint)
      end
    end

    context "with a nil endpoint" do
      let(:new_endpoint) { nil }

      context "when there is no configured endpoint" do
        it "should change to the default endpoint" do
          expect { subject }.to change{client.endpoint}.from(endpoint).to(default_endpoint)
        end
      end

      context "when there is a configured endpoint" do
        let(:configured_endpoint) { 'http://configured.endpoint.com' }
        before { YieldStarClient.configure { |config| config.endpoint = configured_endpoint } }

        it "should change to the configured endpoint" do
          expect { subject }.to change{client.endpoint}.from(endpoint).to(configured_endpoint)
        end
      end
    end
  end

  describe "#username=" do
    subject { client.username = new_username }
    let(:new_username) { 'new username' }

    it "should change the username" do
      expect { subject }.to change{client.username}.from(username).to(new_username)
    end

    context "with a nil username" do
      let(:new_username) { nil }

      context "when there is no configured username" do
        it "should change the username to nil" do
          expect { subject }.to change{client.username}.from(username).to(nil)
        end
      end

      context "when there is a configured username" do
        let(:configured_username) { 'configured user' }
        before { YieldStarClient.configure { |config| config.username = configured_username } }

        it "should change the username to the configured username" do
          expect { subject }.to change{client.username}.from(username).to(configured_username)
        end
      end
    end
  end

  describe "#password=" do
    subject { client.password = new_password }
    let(:new_password) { 'new secret' }

    it "should change the password" do
      expect { subject }.to change{client.password}.from(password).to(new_password)
    end

    context "with a nil password" do
      let(:new_password) { nil }

      context "when there is no configured password" do
        it "should change the password to nil" do
          expect { subject }.to change{client.password}.from(password).to(nil)
        end
      end

      context "when there is a configured password" do
        let(:configured_password) { 'configured password' }
        before { YieldStarClient.configure { |config| config.password = configured_password } }

        it "should change the password to the configured value" do
          expect { subject }.to change{client.password}.from(password).to(configured_password)
        end
      end
    end
  end

  describe "#debug=" do
    subject { client.debug = new_debug }

    context 'with a boolean value' do
      let(:debug) { false }
      let(:new_debug) { true }

      it 'should change the debug setting' do
        expect { subject }.to change { client.debug? }.from(debug).to(new_debug)
      end
    end

    context 'with nil' do
      let(:debug) { false }
      let(:new_debug) { nil }

      context 'when debug logging is enabled globally' do
        before do
          YieldStarClient.configure { |config| config.debug = true }
        end

        it 'should enable debug logging' do
          expect { subject }.to change { client.debug? }.from(false).to(true)
        end
      end

      context 'when debug logging is disabled globally' do
        let(:debug) { true }
        before do
          YieldStarClient.configure { |config| config.debug = false }
        end

        it 'should disable debug logging' do
          expect { subject }.to change { client.debug? }.from(true).to(false)
        end
      end
    end
  end

  describe "#logger=" do
    subject { client.logger = new_logger }

    context 'with nil' do
      let(:new_logger) { nil }
      context 'when there is a logger configured globally' do
        let(:global_logger) { double() }

        before do
          YieldStarClient.configure { |config| config.logger = global_logger }
        end

        it 'should set the logger to the global logger' do
          subject
          client.logger.should == global_logger
        end
      end
    end

    context 'with custom logger' do
      let(:new_logger) { double() }

      it 'should change the logger' do
        expect { subject }.to change { client.logger }.to(new_logger)
      end
    end
  end

  describe '#client_name=' do
    subject { client.client_name = new_client_name }

    context 'with nil' do
      let(:new_client_name) { nil }

      context 'when there is a client_name configured globally' do
        let(:global_client_name) { 'global_client' }

        before do
          YieldStarClient.configure { |config| config.client_name = global_client_name }
        end

        it 'should change the client name to match the global configuration' do
          expect { subject }.to change { client.client_name }.from(client_name).to(global_client_name)
        end
      end

      context 'when there is no client_name configured globally' do
        it 'should reset the client name' do
          expect { subject }.to change { client.client_name }.from(client_name).to(nil)
        end
      end
    end

    context 'with client name' do
      let(:new_client_name) { 'Some new client name' }

      it 'should change the client_name' do
        expect { subject }.to change { client.client_name }.from(client_name).to(new_client_name)
      end
    end
  end
end
