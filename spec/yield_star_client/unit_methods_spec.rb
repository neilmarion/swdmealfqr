require 'spec_helper'
require 'unit_methods'

describe "unit methods" do
  subject { test_object }
 
  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint') }

  let(:client_name) { 'my_client_name' }
  let(:external_property_id) { 'my_prop_id' }

  it { should respond_to(:get_unit) }

  describe "#get_unit" do
    before { savon.stubs(:get_unit).returns(nil) }

    subject { unit }
    let(:unit) { test_object.get_unit(client_name, external_property_id, unit_name) }
    let(:unit_name) { 'my_unit_name' }
    let(:soap_body) { {:client_name => client_name, :external_property_id => external_property_id, :name => unit_name}}

    context "without a building name" do
      it "should retrieve the data from the service" do
        savon.expects(:get_unit).with(:request => soap_body).returns(:simple_unit)
        subject.should be
      end
    end

    context "with a building name" do
      let(:unit) { test_object.get_unit(client_name, external_property_id, unit_name, building_name) }
      let(:building_name) { 'my_building' }

      it "should retrieve the data from the service" do
        savon.expects(:get_unit).with(:request => soap_body.merge(:building => building_name)).returns(:simple_unit)
        subject.should be
      end
    end

    context "for a minimal unit" do
      before { savon.stubs(:get_unit).returns(:simple_unit) }

      it { should have_key(:external_property_id) }
      its([:external_property_id]) { should == '42' }

      it { should have_key(:floor_plan_name) }
      its([:floor_plan_name]) { should == 'Economy' }

      it { should have_key(:name) }
      its([:name]) { should == '1A' }

      it { should have_key(:availability_status) }
      its([:availability_status]) { should == :occupied_on_notice }
    end

    context "for a fully populated unit" do
      before { savon.stubs(:get_unit).returns(:full_unit) }

      it { should have_key(:external_property_id) }
      its([:external_property_id]) { should == '42' }

      it { should have_key(:floor_plan_name) }
      its([:floor_plan_name]) { should == 'Luxury' }

      it { should have_key(:name) }
      its([:name]) { should == 'Unit 6' }

      it { should have_key(:availability_status) }
      its([:availability_status]) { should == :vacant }

      it { should have_key(:building) }
      its([:building]) { should == '99' }

      it { should have_key(:bed_rooms) }
      its([:bed_rooms]) { should == 6.0 }

      it { should have_key(:bath_rooms) }
      its([:bath_rooms]) { should == 5.3 }

      it { should have_key(:square_footage) }
      its([:square_footage]) { should == 5555 }

      it { should have_key(:unit_type) }
      its([:unit_type]) { should == 'foo' }

      it { should have_key(:make_ready_date) }
      its([:make_ready_date]) { should == Date.new(2011,03,10) }
    end

    describe "validations" do
      it_should_behave_like 'a client_name validator'
      it_should_behave_like 'an external_property_id validator'
      it_should_behave_like 'a required string validator', :unit_name
      it "should allow a nil building" do
        expect { subject }.to_not raise_error(ArgumentError)
      end
    end

    it_should_behave_like "a fault handler", :get_unit
  end

  describe "#get_units" do
    before { savon.stubs(:get_units).returns(nil) }

    subject { units }
    let(:units) { test_object.get_units(client_name, external_property_id) }
    let(:soap_body) { {:client_name => client_name, :external_property_id => external_property_id} }

    context "without a floor_plan name" do
      it "should retrieve the data from the service" do
        savon.expects(:get_units).with(:request => soap_body).returns(:no_units)
        subject.should be
      end
    end

    context "with a floor_plan name" do
      let(:units) { test_object.get_units(client_name, external_property_id, floor_plan_name) }
      let(:floor_plan_name) { 'my_floor_plan' }

      it "should retrieve the data from the service" do
        savon.expects(:get_units).with(:request => soap_body.merge(:floor_plan_name => floor_plan_name)).returns(:no_units)
        subject.should be
      end
    end

    context "for one unit" do
      before { savon.stubs(:get_units).returns(:single_unit) }

      it { should be }
      it { should have(1).unit }

      describe "first unit" do
        subject { units.first }

        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '42' }

        it { should have_key(:floor_plan_name) }
        its([:floor_plan_name]) { should == 'FP99' }

        it { should have_key(:name) }
        its([:name]) { should == 'Unit 1' }

        it { should have_key(:availability_status) }
        its([:availability_status]) { should == :occupied }
      end
    end

    context "for multiple units" do
      before { savon.stubs(:get_units).returns(:multiple_units) }

      it { should be }
      it { should have(2).units }

      describe "first unit" do
        subject { units.first }

        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '42' }

        it { should have_key(:floor_plan_name) }
        its([:floor_plan_name]) { should == 'Economy' }

        it { should have_key(:name) }
        its([:name]) { should == 'Apt 313' }

        it { should have_key(:bed_rooms) }
        its([:bed_rooms]) { should == 2.0 }

        it { should have_key(:bath_rooms) }
        its([:bath_rooms]) { should == 1.1 }

        it { should have_key(:square_footage) }
        its([:square_footage]) { should == 1000 }

        it { should have_key(:unit_type) }
        its([:unit_type]) { should == 'apartment' }

        it { should have_key(:availability_status) }
        its([:availability_status]) { should == :pending }
      end

      describe "last unit" do
        subject { units.last }

        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '42' }

        it { should have_key(:floor_plan_name) }
        its([:floor_plan_name]) { should == 'Luxury' }

        it { should have_key(:name) }
        its([:name]) { should == 'The Villa' }

        it { should have_key(:bed_rooms) }
        its([:bed_rooms]) { should == 6.0 }

        it { should have_key(:bath_rooms) }
        its([:bath_rooms]) { should == 4.0 }

        it { should have_key(:square_footage) }
        its([:square_footage]) { should == 5000 }

        it { should have_key(:unit_type) }
        its([:unit_type]) { should == 'single-family home' }

        it { should have_key(:building) }
        its([:building]) { should == '99' }

        it { should have_key(:make_ready_date) }
        its([:make_ready_date]) { should == Date.new(2011, 4, 1) }

        it { should have_key(:availability_status) }
        its([:availability_status]) { should == :unknown }
      end
    end

    context "for no units" do
      before { savon.stubs(:get_units).returns(:no_units) }

      it { should be }
      it { should be_empty }
    end

    describe "validations" do
      it_should_behave_like 'a client_name validator'
      it_should_behave_like 'an external_property_id validator'

      it "should allow a nil floor_plan_name" do
        expect { subject }.to_not raise_error(ArgumentError)
      end
    end

    it_should_behave_like 'a fault handler', :get_units
  end
end
