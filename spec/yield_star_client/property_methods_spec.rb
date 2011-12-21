require 'spec_helper'

describe "property methods" do
  subject { test_object }
  
  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint', :client_name => client_name) }

  let(:client_name) { 'my client name' }
  let(:external_property_id) { 'my-external-property-id' }

  it { should respond_to(:get_properties) }
  it { should respond_to(:get_property) }
  it { should respond_to(:get_property_parameters) }

  describe "#get_properties" do
    before { savon.stubs(:get_properties).returns(nil) }

    subject { properties }
    let(:properties) { test_object.get_properties }

    it "should retrieve the property data by client_name from the service" do
      savon.expects(:get_properties).with(:request => {:client_name => client_name}).returns(:single_property)
      subject.should be
    end

    context "with no properties" do
      before { savon.stubs(:get_properties).returns(:no_property) }

      it { should be }
      it { should be_empty }
    end

    context "with single property" do
      before { savon.stubs(:get_properties).returns(:single_property) }

      it { should have(1).property }

      describe "first property" do
        subject { properties.first }
 
        its(:name) { should == 'Minimal' }
        its(:external_property_id) { should == '1' }
      end
    end

    context "with multiple properties" do
      before { savon.stubs(:get_properties).returns(:multiple_properties) }

      it { should have(2).properties }

      describe "first property" do
        subject { properties.first }

        its(:external_property_id) { should == '2' }
        its(:name) { should == 'Typical' }
        its(:address) { should == '123 Address Ln' }
        its(:city) { should == 'Beverly Hills' }
        its(:state) { should == 'CA' }
        its(:zip) { should == '90210' }
        its(:longitude) { should == -122.605687 }
        its(:latitude) { should == 45.544873 }
        its(:phone) { should_not be }
        its(:fax) { should_not be }
        its(:year_built) { should == 2009 }
        its(:unit_count) { should_not be }
        its(:website) { should_not be }
      end

      describe "last property" do
        subject { properties.last }

        its(:external_property_id) { should == '3' }
        its(:name) { should == 'Fully Loaded' }
        its(:address) { should == '550 NW Franklin Ave #200' }
        its(:city) { should == 'Bend' }
        its(:state) { should == 'OR' }
        its(:zip) { should == '97701' }
        its(:longitude) { should == -121.313936 }
        its(:latitude) { should == 44.057411 }
        its(:phone) { should == '5413063374' }
        its(:fax) { should == '1234567890' }
        its(:website) { should == 'http://g5platform.com' }
        its(:unit_count) { should == 100 }
        its(:year_built) { should == 2008 }
      end
    end

    it_should_behave_like "a client_name validator"

    it_should_behave_like "a fault handler", :get_properties
  end

  describe "#get_property" do
    before { savon.stubs(:get_property).returns(nil) }

    subject { property }
    let(:property) { test_object.get_property(external_property_id) }
    
    it "should retrieve the property data from the service" do
      savon.expects(:get_property).
        with(:request => {:client_name => client_name, :external_property_id => external_property_id}).
        returns(:simple_property)
      subject.should be
    end

    context "for a simple property" do
      before { savon.stubs(:get_property).returns(:simple_property) }

      its(:external_property_id) { should == '42' }
      its(:name) { should == 'Galaxy Apartments' }
    end

    context "for a fully specified property" do
      before { savon.stubs(:get_property).returns(:full_property) }

      its(:external_property_id) { should == '99' }
      its(:name) { should == 'Full Property' }
      its(:address) { should == '123 My Street' }
      its(:city) { should == 'Anywhere' }
      its(:state) { should == 'AK' }
      its(:zip) { should == '99999' }
      its(:longitude) { should == -95.514257 }
      its(:latitude) { should == 29.732654 }
      its(:year_built) { should == 2008 }
      its(:phone) { should == '555-555-5555' }
      its(:fax) { should == '999-999-9999' }
      its(:website) { should == 'http://google.com' }
      its(:unit_count) { should == 100 }
    end

    # Validations
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'

    # Error handling
    it_should_behave_like "a fault handler", :get_property 
  end

  describe "#get_property_parameters" do
    before { savon.stubs(:get_property_parameters).returns(nil) }

    subject { parameters }
    let(:parameters) { test_object.get_property_parameters(external_property_id) }

    it "should retrieve the data from the service" do
      savon.expects(:get_property_parameters).
        with(:request => {:client_name => client_name, :external_property_id => external_property_id}).
        returns(:no_parameters)
      subject.should be
    end

    context "with empty parameters" do
      before { savon.stubs(:get_property_parameters).returns(:no_parameters) }

      it { should be }
      its(:external_property_id) { should == external_property_id }
    end

    context "with partial parameters" do
      before { savon.stubs(:get_property_parameters).returns(:simple_parameters) }

      it { should be }
      its(:external_property_id) { should == external_property_id }
      its(:post_date) { should == Date.new(2011, 3, 2) }
    end

    context "with full parameters" do
      before { savon.stubs(:get_property_parameters).returns(:full_parameters) }

      it { should be }

      its(:external_property_id) { should == external_property_id }
      its(:new_lease_term_options) { should == 3 }
      its(:post_date) { should == Date.new(2011, 3, 1) }
      its(:max_renewal_lease_term) { should == 15 }
      its(:min_new_lease_term) { should == 1 }
      its(:min_renewal_lease_term) { should == 1 }
      its(:max_new_lease_term) { should == 15 }
      its(:max_move_in_days) { should == 55 }
    end

    # Validations
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'

    # Error handling
    it_should_behave_like "a fault handler", :get_property_parameters
  end
end
