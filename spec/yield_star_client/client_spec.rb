require 'spec_helper'

describe YieldStarClient::Client do
  subject { client }

  after { YieldStarClient.reset }

  let(:client) do
    YieldStarClient::Client.new({:endpoint => endpoint, 
                                 :username => username, 
                                 :password => password,
                                 :namespace => namespace})
  end

  let(:endpoint) { 'https://foo.com?wsdl' }
  let(:default_endpoint) { YieldStarClient::DEFAULT_ENDPOINT }
  let(:username) { 'test_user' }
  let(:password) { 'secret' }
  let(:namespace) { 'http://foo.com/namespace' }

  its(:endpoint) { should == endpoint }
  its(:username) { should == username }
  its(:password) { should == password }
  its(:namespace) { should == namespace }

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
  it { should respond_to(:get_available_units) }

  context "with default configuration" do
    let(:client) { YieldStarClient::Client.new }

    its(:endpoint) { should == default_endpoint }
    its(:username) { should_not be }
    its(:password) { should_not be }
    its(:namespace) { should == YieldStarClient::DEFAULT_NAMESPACE }
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
end
