require 'spec_helper'

describe "floor plan methods" do
  subject { test_object }

  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint', :client_name => client_name) }

  let(:client_name) { 'my_client_name' }
  let(:external_property_id) { 'my_external_property_id' }

  it { should respond_to(:get_floor_plan) }

  describe "#get_floor_plan" do
    before { savon.stubs(:get_floor_plan).returns(nil) }

    subject { floor_plan }
    let(:floor_plan) { test_object.get_floor_plan(external_property_id, floor_plan_name) }
    let(:floor_plan_name) { 'my_floor_plan_name' }

    it "should retrieve the floor plan data from the service" do
      savon.expects(:get_floor_plan).
        with(:request => {:client_name => client_name, :external_property_id => external_property_id, :name => floor_plan_name}).
        returns(:simple_floor_plan)
      subject.should be
    end

    context "with a minimal floor plan" do
      before { savon.stubs(:get_floor_plan).returns(:simple_floor_plan) }

      its(:external_property_id) { should == '42' }
      its(:name) { should == 'simple-plan' }
    end

    context "with a fully defined floor plan" do
      before { savon.stubs(:get_floor_plan).returns(:full_floor_plan) }

      its(:external_property_id) { should == '99' }
      its(:name) { should == 'The Oxford' }
      its(:description) { should == 'An apartment' }
      its(:square_feet) { should == 797 }
      its(:unit_count) { should == 49 }
      its(:bedrooms) { should == 1.0 }
      its(:bathrooms) { should == 1.1 }
    end

    # Validations
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'
    it_should_behave_like 'a required string validator', :floor_plan_name      
    
    # Error handling
    it_should_behave_like 'a fault handler', :get_floor_plan
  end

  it { should respond_to(:get_floor_plans) }

  describe "#get_floor_plans" do
    before { savon.stubs(:get_floor_plans).returns(nil) }

    subject { floor_plans }
    let(:floor_plans) { test_object.get_floor_plans(external_property_id) }

    it "should retrieve the floor plan data from the service" do
      savon.expects(:get_floor_plans).
        with(:request => {:client_name => client_name, :external_property_id => external_property_id}).
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

        its(:external_property_id) { should == '42' }
        its(:name) { should == 'simple' }
        its(:description) { should == 'A simple floor plan.' }
      end
    end

    context "with multiple floor plans" do
      before { savon.stubs(:get_floor_plans).returns(:multiple_floor_plans) }

      describe "first floor plan" do
        subject { floor_plans.first }

        its(:external_property_id) { should == '99' }
        its(:name) { should == 'The Economy' }
        its(:description) { should == 'An affordable choice for the frugal resident.' }
        its(:square_feet) { should == 450 }
        its(:unit_count) { should == 42 }
        its(:bedrooms) { should == 1.0 }
        its(:bathrooms) { should == 1.0 }
      end

      describe "last floor plan" do
        subject { floor_plans.last }

        its(:external_property_id) { should == '99' }
        its(:name) { should == 'The Luxury' }
        its(:description) { should == 'A palatial estate for the independently wealthy.' }
        its(:square_feet) { should == 10000 }
        its(:unit_count) { should == 3 }
        its(:bedrooms) { should == 7.0 }
        its(:bathrooms) { should == 7.3 }
      end
    end

    # Validation
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'

    # Error handling
    it_should_behave_like 'a fault handler', :get_floor_plans
  end
end
