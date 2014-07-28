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

      it "has the correct attributes" do
        expect(subject.external_property_id).to eq '42'
        expect(subject.name).to eq 'simple-plan'
      end
    end

    context "with a fully defined floor plan" do
      before { savon.stubs(:get_floor_plan).returns(:full_floor_plan) }

      it "has the correct attributes" do
        expect(subject.external_property_id).to eq '99'
        expect(subject.name).to eq 'The Oxford'
        expect(subject.description).to eq 'An apartment'
        expect(subject.square_feet).to eq 797
        expect(subject.unit_count).to eq 49
        expect(subject.bedrooms).to eq 1.0
        expect(subject.bathrooms).to eq 1.1
      end
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

      it "has 1 floor plan" do
        expect(subject.size).to eq 1
      end

      describe "first floor plan" do
        subject { floor_plans.first }

        it "is the correct floor plan" do
          expect(subject.external_property_id).to eq '42'
          expect(subject.name).to eq 'simple'
          expect(subject.description).to eq 'A simple floor plan.'
        end
      end
    end

    context "with multiple floor plans" do
      before { savon.stubs(:get_floor_plans).returns(:multiple_floor_plans) }

      describe "first floor plan" do
        subject { floor_plans.first }

        it "is the correct floor plan" do
          expect(subject.external_property_id).to eq '99'
          expect(subject.name).to eq 'The Economy'
          expect(subject.description).to eq 'An affordable choice for the frugal resident.'
          expect(subject.square_feet).to eq 450
          expect(subject.unit_count).to eq 42
          expect(subject.bedrooms).to eq 1.0
          expect(subject.bathrooms).to eq 1.0
        end
      end

      describe "last floor plan" do
        subject { floor_plans.last }

        it "is the correct floor plan" do
          expect(subject.external_property_id).to eq '99'
          expect(subject.name).to eq 'The Luxury'
          expect(subject.description).to eq 'A palatial estate for the independently wealthy.'
          expect(subject.square_feet).to eq 10000
          expect(subject.unit_count).to eq 3
          expect(subject.bedrooms).to eq 7.0
          expect(subject.bathrooms).to eq 7.3
        end
      end
    end

    # Validation
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'

    # Error handling
    it_should_behave_like 'a fault handler', :get_floor_plans
  end
end
