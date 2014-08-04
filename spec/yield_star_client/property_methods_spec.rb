require 'spec_helper'

describe YieldStarClient::Client do
  describe "#get_properties", vcr: {record: :once} do
    it "returns properties" do
      client = described_class.new(CONFIG.merge(
        debug: true,
        logger: Logger.new("tmp/test.log"),
      ))

      properties = client.get_properties
      expect(properties).to_not be_empty
    end
  end
end

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

      it "has 1 property" do
        expect(subject.size).to eq 1
      end

      describe "first property" do
        subject { properties.first }

        it "has the correct attributes" do
          expect(subject.name).to eq 'Minimal'
          expect(subject.external_property_id).to eq '1'
        end
      end
    end

    context "with multiple properties" do
      before { savon.stubs(:get_properties).returns(:multiple_properties) }

      it "has 2 properties" do
        expect(subject.size).to eq 2
      end

      describe "first property" do
        subject { properties.first }

        it "has the correct attributes" do
          expect(subject.external_property_id).to eq '2'
          expect(subject.name).to eq 'Typical'
          expect(subject.address).to eq '123 Address Ln'
          expect(subject.city).to eq 'Beverly Hills'
          expect(subject.state).to eq 'CA'
          expect(subject.zip).to eq '90210'
          expect(subject.longitude).to eq(-122.605687)
          expect(subject.latitude).to eq 45.544873
          expect(subject.phone).to be_blank
          expect(subject.fax).to be_blank
          expect(subject.year_built).to eq 2009
          expect(subject.unit_count).to be_blank
          expect(subject.website).to be_blank
        end
      end

      describe "last property" do
        subject { properties.last }

        it "has the correct attributes" do
          expect(subject.external_property_id).to eq '3'
          expect(subject.name).to eq 'Fully Loaded'
          expect(subject.address).to eq '550 NW Franklin Ave #200'
          expect(subject.city).to eq 'Bend'
          expect(subject.state).to eq 'OR'
          expect(subject.zip).to eq '97701'
          expect(subject.longitude).to eq(-121.313936)
          expect(subject.latitude).to eq 44.057411
          expect(subject.phone).to eq '5413063374'
          expect(subject.fax).to eq '1234567890'
          expect(subject.website).to eq 'http://g5platform.com'
          expect(subject.unit_count).to eq 100
          expect(subject.year_built).to eq 2008
        end
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

      it "has the correct attributes" do
        expect(subject.external_property_id).to eq '42'
        expect(subject.name).to eq 'Galaxy Apartments'
      end
    end

    context "for a fully specified property" do
      before { savon.stubs(:get_property).returns(:full_property) }

      it "has the correct attributes" do
        expect(subject.external_property_id).to eq '99'
        expect(subject.name).to eq 'Full Property'
        expect(subject.address).to eq '123 My Street'
        expect(subject.city).to eq 'Anywhere'
        expect(subject.state).to eq 'AK'
        expect(subject.zip).to eq '99999'
        expect(subject.longitude).to eq(-95.514257)
        expect(subject.latitude).to eq 29.732654
        expect(subject.year_built).to eq 2008
        expect(subject.phone).to eq '555-555-5555'
        expect(subject.fax).to eq '999-999-9999'
        expect(subject.website).to eq 'http://google.com'
        expect(subject.unit_count).to eq 100
      end
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

      it "has the correct attributes" do
        expect(subject.external_property_id).to eq external_property_id
      end
    end

    context "with partial parameters" do
      before { savon.stubs(:get_property_parameters).returns(:simple_parameters) }

      it { should be }

      it "has the correct attributes" do
        expect(subject.external_property_id).to eq external_property_id
        expect(subject.post_date).to eq Date.new(2011, 3, 2)
      end
    end

    context "with full parameters" do
      before { savon.stubs(:get_property_parameters).returns(:full_parameters) }

      it { should be }

      it "has the correct attributes" do
        expect(subject.external_property_id).to eq external_property_id
        expect(subject.new_lease_term_options).to eq 3
        expect(subject.post_date).to eq Date.new(2011, 3, 1)
        expect(subject.max_renewal_lease_term).to eq 15
        expect(subject.min_new_lease_term).to eq 1
        expect(subject.min_renewal_lease_term).to eq 1
        expect(subject.max_new_lease_term).to eq 15
        expect(subject.max_move_in_days).to eq 55
      end
    end

    # Validations
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'

    # Error handling
    it_should_behave_like "a fault handler", :get_property_parameters
  end
end
