require 'spec_helper'

describe "property methods" do
  subject { test_object }
  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint') }
  let(:client_name) { 'my client name' }
  let(:external_property_id) { 'my-external-property-id' }

  it { should respond_to(:get_properties) }
  it { should respond_to(:get_property) }
  it { should respond_to(:get_property_parameters) }

  describe "#get_properties" do
    before { savon.stubs(:get_properties).returns(nil) }

    subject { properties }
    let(:properties) { test_object.get_properties(client_name) }

    it "should retrieve the property data by client_name from the service" do
      savon.expects(:get_properties).with(:request => {:client_name => client_name}).returns(:single_property)
      subject.should be
    end

    context "with single property" do
      before { savon.stubs(:get_properties).returns(:single_property) }

      it { should have(1).property }

      describe "first property" do
        subject { properties.first }

        it { should have(2).keys }
 
        it { should have_key(:name) }
        its([:name]) { should == 'Minimal' }
 
        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '1' }
      end
    end

    context "with multiple properties" do
      before { savon.stubs(:get_properties).returns(:multiple_properties) }

      it { should have(2).properties }

      describe "first property" do
        subject { properties.first }

        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '2' }

        it { should have_key(:name) }
        its([:name]) { should == 'Typical' }

        it { should have_key(:address) }
        its([:address]) { should == '123 Address Ln' }

        it { should have_key(:city) }
        its([:city]) { should == 'Beverly Hills' }

        it { should have_key(:state) }
        its([:state]) { should == 'CA' }

        it { should have_key(:zip) }
        its([:zip]) { should == '90210' }

        it { should have_key(:longitude) }
        its([:longitude]) { should == -122.605687 }

        it { should have_key(:latitude) }
        its([:latitude]) { should == 45.544873 }

        it { should have_key(:phone) }
        its([:phone]) { should_not be }

        it { should have_key(:fax) }
        its([:fax]) { should_not be }

        it { should have_key(:year_built) }
        its([:year_built]) { should == 2009 }

        it { should_not have_key(:unit_count) }
        it { should_not have_key(:website) }
      end

      describe "last property" do
        subject { properties.last }

        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '3' }

        it { should have_key(:name) }
        its([:name]) { should == 'Fully Loaded' }

        it { should have_key(:address) }
        its([:address]) { should == '550 NW Franklin Ave #200' }

        it { should have_key(:city) }
        its([:city]) { should == 'Bend' }

        it { should have_key(:state) }
        its([:state]) { should == 'OR' }

        it { should have_key(:zip) }
        its([:zip]) { should == '97701' }

        it { should have_key(:longitude) }
        its([:longitude]) { should == -121.313936 }

        it { should have_key(:latitude) }
        its([:latitude]) { should == 44.057411 }

        it { should have_key(:phone) }
        its([:phone]) { should == '5413063374' }

        it { should have_key(:fax) }
        its([:fax]) { should == '1234567890' }

        it { should have_key(:website) }
        its([:website]) { should == 'http://g5platform.com' }

        it { should have_key(:unit_count) }
        its([:unit_count]) { should == 100 }

        it { should have_key(:year_built) }
        its([:year_built]) { should == 2008 }
      end
    end

    it_should_behave_like "a client_name validator"

    it_should_behave_like "a fault handler", :get_properties
  end

  describe "#get_property" do
    before { savon.stubs(:get_property).returns(nil) }

    subject { property }
    let(:property) { test_object.get_property(client_name, external_property_id) }
    
    it "should retrieve the property data from the service" do
      savon.expects(:get_property).
        with(:client_name => client_name, :external_property_id => external_property_id).
        returns(:simple_property)
      subject.should be
    end

    context "for a simple property" do
      before { savon.stubs(:get_property).returns(:simple_property) }

      it { should have(2).keys }

      it { should have_key(:external_property_id) }
      its([:external_property_id]) { should == '42' }

      it { should have_key(:name) }
      its([:name]) { should == 'Galaxy Apartments' }
    end

    context "for a fully specified property" do
      before { savon.stubs(:get_property).returns(:full_property) }

      it { should have_key(:external_property_id) }
      its([:external_property_id]) { should == '99' }

      it { should have_key(:name) }
      its([:name]) { should == 'Full Property' }

      it { should have_key(:address) }
      its([:address]) { should == '123 My Street' }

      it { should have_key(:city) }
      its([:city]) { should == 'Anywhere' }

      it { should have_key(:state) }
      its([:state]) { should == 'AK' }

      it { should have_key(:zip) }
      its([:zip]) { should == '99999' }

      it { should have_key(:longitude) }
      its([:longitude]) { should == -95.514257 }

      it { should have_key(:latitude) }
      its([:latitude]) { should == 29.732654 }

      it { should have_key(:year_built) }
      its([:year_built]) { should == 2008 }

      it { should have_key(:phone) }
      its([:phone]) { should == '555-555-5555' }

      it { should have_key(:fax) }
      its([:fax]) { should == '999-999-9999' }

      it { should have_key(:website) }
      its([:website]) { should == 'http://google.com' }

      it { should have_key(:unit_count) }
      its([:unit_count]) { should == 100 }
    end

    describe "validation" do
      it_should_behave_like 'a client_name validator'
      it_should_behave_like 'an external_property_id validator'
    end

    it_should_behave_like "a fault handler", :get_property 
  end

  describe "#get_property_parameters" do
    before { savon.stubs(:get_property_parameters).returns(nil) }

    subject { parameters }
    let(:parameters) { test_object.get_property_parameters(client_name, external_property_id) }

    it "should retrieve the data from the service" do
      savon.expects(:get_property_parameters).
        with(:client_name => client_name, :external_property_id => external_property_id).
        returns(:no_parameters)
      subject.should be
    end

    context "with empty parameters" do
      before { savon.stubs(:get_property_parameters).returns(:no_parameters) }

      it { should be }
      it { should be_empty }
    end

    context "with partial parameters" do
      before { savon.stubs(:get_property_parameters).returns(:simple_parameters) }

      it { should be }

      it { should have(1).parameter }

      it { should have_key(:post_date) }
      its([:post_date]) { should == Date.new(2011, 3, 2) }
    end

    context "with full parameters" do
      before { savon.stubs(:get_property_parameters).returns(:full_parameters) }

      it { should be }

      it { should have(7).parameters }
    
      it { should have_key(:new_lease_term_options) }
      its([:new_lease_term_options]) { should == 3 }

      it { should have_key(:post_date) }
      its([:post_date]) { should == Date.new(2011, 3, 1) }

      it { should have_key(:max_renewal_lease_term) }
      its([:max_renewal_lease_term]) { should == 15 }

      it { should have_key(:min_new_lease_term) }
      its([:min_new_lease_term]) { should == 1 }

      it { should have_key(:min_renewal_lease_term) }
      its([:min_renewal_lease_term]) { should == 1 }

      it { should have_key(:max_new_lease_term) }
      its([:max_new_lease_term]) { should == 15 }

      it { should have_key(:max_move_in_days) }
      its([:max_move_in_days]) { should == 55 }
    end

    describe "validation" do
      it_should_behave_like 'a client_name validator'
      it_should_behave_like 'an external_property_id validator'
    end

    it_should_behave_like "a fault handler", :get_property_parameters
  end
end
