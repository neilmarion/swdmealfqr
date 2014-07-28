require 'spec_helper'

describe "unit methods" do
  subject { test_object }
 
  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint', :client_name => client_name) }

  let(:client_name) { 'my_client_name' }
  let(:external_property_id) { 'my_prop_id' }

  it { should respond_to(:get_unit) }
  it { should respond_to(:get_units) }

  describe "#get_unit" do
    before { savon.stubs(:get_unit).returns(nil) }

    subject { unit }
    let(:unit) { test_object.get_unit(external_property_id, unit_name) }
    let(:unit_name) { 'my_unit_name' }
    let(:soap_body) { {:client_name => client_name, :external_property_id => external_property_id, :name => unit_name}}

    context "without a building name" do
      it "should retrieve the data from the service" do
        savon.expects(:get_unit).with(:request => soap_body).returns(:simple_unit)
        subject.should be
      end
    end

    context "with a building name" do
      let(:unit) { test_object.get_unit(external_property_id, unit_name, building_name) }
      let(:building_name) { 'my_building' }

      it "should retrieve the data from the service" do
        savon.expects(:get_unit).with(:request => soap_body.merge(:building => building_name)).returns(:simple_unit)
        subject.should be
      end
    end

    context "for a minimal unit" do
      before { savon.stubs(:get_unit).returns(:simple_unit) }

      it "has the correct attributes" do
        expect(subject.external_property_id).to eq '42'
        expect(subject.floor_plan_name).to eq 'Economy'
        expect(subject.name).to eq '1A'
        expect(subject.availability_status).to eq :occupied_on_notice
      end
    end

    context "for a fully populated unit" do
      before { savon.stubs(:get_unit).returns(:full_unit) }

      it "has the correct attributes" do
        expect(subject.external_property_id).to eq '42'
        expect(subject.floor_plan_name).to eq 'Luxury'
        expect(subject.name).to eq 'Unit 6'
        expect(subject.availability_status).to eq :vacant
        expect(subject.building).to eq '99'
        expect(subject.bedrooms).to eq 6.0
        expect(subject.bathrooms).to eq 5.3
        expect(subject.square_feet).to eq 5555
        expect(subject.unit_type).to eq 'foo'
        expect(subject.make_ready_date).to eq Date.new(2011,03,10)
      end
    end

    # Validation
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'
    it_should_behave_like 'a required string validator', :unit_name

    # Error handling
    it_should_behave_like "a fault handler", :get_unit
  end

  describe "#get_units" do
    before { savon.stubs(:get_units).returns(nil) }

    subject { units }
    let(:units) { test_object.get_units(external_property_id) }
    let(:soap_body) { {:client_name => client_name, :external_property_id => external_property_id} }

    context "without a floor_plan name" do
      it "should retrieve the data from the service" do
        savon.expects(:get_units).with(:request => soap_body).returns(:no_units)
        subject.should be
      end
    end

    context "with a floor_plan name" do
      let(:units) { test_object.get_units(external_property_id, floor_plan_name) }
      let(:floor_plan_name) { 'my_floor_plan' }

      it "should retrieve the data from the service" do
        savon.expects(:get_units).with(:request => soap_body.merge(:floor_plan_name => floor_plan_name)).returns(:no_units)
        subject.should be
      end
    end

    context "for one unit" do
      before { savon.stubs(:get_units).returns(:single_unit) }

      it { should be }

      it "has 1 unit" do
        expect(subject.size).to eq 1
      end

      describe "first unit" do
        subject { units.first }

        it "has the correct attributes" do
          expect(subject.external_property_id).to eq '42'
          expect(subject.floor_plan_name).to eq 'FP99'
          expect(subject.name).to eq 'Unit 1'
          expect(subject.availability_status).to eq :occupied
        end
      end
    end

    context "for multiple units" do
      before { savon.stubs(:get_units).returns(:multiple_units) }

      it { should be }

      it "has 2 units" do
        expect(subject.size).to eq 2
      end

      describe "first unit" do
        subject { units.first }

        it "has the correct attributes" do
          expect(subject.external_property_id).to eq '42'
          expect(subject.floor_plan_name).to eq 'Economy'
          expect(subject.name).to eq 'Apt 313'
          expect(subject.bedrooms).to eq 2.0
          expect(subject.bathrooms).to eq 1.1
          expect(subject.square_feet).to eq 1000
          expect(subject.unit_type).to eq 'apartment'
          expect(subject.availability_status).to eq :pending
        end
      end

      describe "last unit" do
        subject { units.last }

        it "has the correct attributes" do
          expect(subject.external_property_id).to eq '42'
          expect(subject.floor_plan_name).to eq 'Luxury'
          expect(subject.name).to eq 'The Villa'
          expect(subject.bedrooms).to eq 6.0
          expect(subject.bathrooms).to eq 4.0
          expect(subject.square_feet).to eq 5000
          expect(subject.unit_type).to eq 'single-family home'
          expect(subject.building).to eq '99'
          expect(subject.make_ready_date).to eq Date.new(2011, 4, 1)
          expect(subject.availability_status).to eq :unknown
        end
      end
    end

    context "for no units" do
      before { savon.stubs(:get_units).returns(:no_units) }

      it { should be }
      it { should be_empty }
    end

    # Validation
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'

    # Error handling
    it_should_behave_like 'a fault handler', :get_units
  end
end
