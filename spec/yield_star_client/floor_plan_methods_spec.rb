require 'spec_helper'

describe "floor plan methods" do
  subject { test_object }
  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint') }
  let(:client_name) { 'my_client_name' }
  let(:external_property_id) { 'my_external_property_id' }

  it { should respond_to(:get_floor_plan) }

  describe "#get_floor_plan" do
    before { savon.stubs(:get_floor_plan).returns(nil) }

    subject { floor_plan }
    let(:floor_plan) { test_object.get_floor_plan(client_name, external_property_id, floor_plan_name) }
    let(:floor_plan_name) { 'my_floor_plan_name' }

    it "should retrieve the floor plan data from the service" do
      savon.expects(:get_floor_plan).
        with(:client_name => client_name, :external_property_id => external_property_id, :name => floor_plan_name).
        returns(:simple_floor_plan)
      subject.should be
    end

    context "with a minimal floor plan" do
      before { savon.stubs(:get_floor_plan).returns(:simple_floor_plan) }

      it { should have(2).attributes }

      it { should have_key(:external_property_id) }
      its([:external_property_id]) { should == '42' }

      it { should have_key(:name) }
      its([:name]) { should == 'simple-plan' }
    end

    context "with a fully defined floor plan" do
      before { savon.stubs(:get_floor_plan).returns(:full_floor_plan) }

      it { should have(7).attributes }

      it { should have_key(:external_property_id) }
      its([:external_property_id]) { should == '99' }
      
      it { should have_key(:name) }
      its([:name]) { should == 'The Oxford' }

      it { should have_key(:description) }
      its([:description]) { should == 'An apartment' }

      it { should have_key(:square_footage) }
      its([:square_footage]) { should == 797 }

      it { should have_key(:unit_count) }
      its([:unit_count]) { should == 49 }

      it { should have_key(:bed_rooms) }
      its([:bed_rooms]) { should == 1.0 }

      it { should have_key(:bath_rooms) }
      its([:bath_rooms]) { should == 1.1 }
    end

    describe "validation" do
      it_should_behave_like 'a client_name validator'
      it_should_behave_like 'an external_property_id validator'
      it_should_behave_like 'a required string validator', :floor_plan_name      
    end

    it_should_behave_like 'a fault handler', :get_floor_plan
  end

  it { should respond_to(:get_floor_plans) }

  describe "#get_floor_plans" do
    before { savon.stubs(:get_floor_plans).returns(nil) }

    subject { floor_plans }
    let(:floor_plans) { test_object.get_floor_plans(client_name, external_property_id) }

    it "should retrieve the floor plan data from the service" do
      savon.expects(:get_floor_plans).
        with(:client_name => client_name, :external_property_id => external_property_id).
        returns(:single_floor_plan)
      subject.should be
    end

    context "with no floor plan" do
      before { savon.stubs(:get_floor_plans).returns(:no_floor_plan) }

      it { should be }
      it { should be_empty }
    end

    context "with one floor plan" do
      before { savon.stubs(:get_floor_plans).returns(:single_floor_plan) }

      it { should have(1).floor_plan }

      describe "first floor plan" do
        subject { floor_plans.first }

        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '42' }

        it { should have_key(:name) }
        its([:name]) { should == 'simple' }

        it { should have_key(:description) }
        its([:description]) { should == 'A simple floor plan.' }
      end
    end

    context "with multiple floor plans" do
      before { savon.stubs(:get_floor_plans).returns(:multiple_floor_plans) }

      it { should have(2).floor_plans }

      describe "first floor plan" do
        subject { floor_plans.first }

        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '99' }

        it { should have_key(:name) }
        its([:name]) { should == 'The Economy' }

        it { should have_key(:description) }
        its([:description]) { should == 'An affordable choice for the frugal resident.' }

        it { should have_key(:square_footage) }
        its([:square_footage]) { should == 450 }

        it { should have_key(:unit_count) }
        its([:unit_count]) { should == 42 }

        it { should have_key(:bed_rooms) }
        its([:bed_rooms]) { should == 1.0 }

        it { should have_key(:bath_rooms) }
        its([:bath_rooms]) { should == 1.0 }
      end

      describe "last floor plan" do
        subject { floor_plans.last }

        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '99' }

        it { should have_key(:name) }
        its([:name]) { should == 'The Luxury' }

        it { should have_key(:description) }
        its([:description]) { should == 'A palatial estate for the independently wealthy.' }

        it { should have_key(:square_footage) }
        its([:square_footage]) { should == 10000 }

        it { should have_key(:unit_count) }
        its([:unit_count]) { should == 3 }

        it { should have_key(:bed_rooms) }
        its([:bed_rooms]) { should == 7.0 }

        it { should have_key(:bath_rooms) }
        its([:bath_rooms]) { should == 7.3 }
      end
    end

    describe "validation" do
      it_should_behave_like 'a client_name validator'
      it_should_behave_like 'an external_property_id validator'
    end

    it_should_behave_like 'a fault handler', :get_floor_plans
  end
end
