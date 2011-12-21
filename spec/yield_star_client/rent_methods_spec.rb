require 'spec_helper'

describe "rental/availability methods" do
  subject { test_object }

  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint', :client_name => client_name) }

  let(:client_name) { 'my_client_name' }
  let(:external_property_id) { '42' }

  it { should respond_to(:get_rent_summary) }

  describe "#get_rent_summary" do
    before { savon.stubs(:get_rent_summary).returns(nil) }

    subject { rent_summaries }
    let(:rent_summaries) { test_object.get_rent_summary(external_property_id) }

    it "should retrieve the data from the service" do
      savon.expects(:get_rent_summary).
        with(:request => {:client_name => client_name, :external_property_id => external_property_id}).
        returns(:no_summaries)
      subject.should be
    end

    context "with no summaries" do
      before { savon.stubs(:get_rent_summary).returns(:no_summaries) }

      it { should be_empty }
    end

    context "with one summary" do
      before { savon.stubs(:get_rent_summary).returns(:single_summary) }

      it { should have(1).summary }

      describe "the first summary" do
        subject { rent_summaries.first }

        its(:external_property_id) { should == external_property_id }
        its(:effective_date) { should == Date.civil(2011, 3, 11) }
        its(:floor_plan_name) { should == '99' }
        its(:unit_type) { should == '1b1ba' }
        its(:bedrooms) { should == 1.0 }
        its(:bathrooms) { should == 1.0 }
        its(:avg_square_feet) { should == 797 }
        its(:min_market_rent) { should == 765 }
        its(:max_market_rent) { should == 820 }
        its(:min_concession) { should == 500 }
        its(:max_concession) { should == 500 }
        its(:min_final_rent) { should == 807 }
        its(:max_final_rent) { should == 862 }
      end
    end

    context "with multiple summaries" do
      before { savon.stubs(:get_rent_summary).returns(:multiple_summaries) }
      let(:effective_date) { Date.civil(2011, 3, 15) }
      it { should have(2).summaries }

      describe "the first summary" do
        subject { rent_summaries.first }

        its(:external_property_id) { should == external_property_id }
        its(:effective_date) { should == effective_date }
        its(:floor_plan_name) { should == 'Economy' }
        its(:unit_type) { should == '2b1.5ba' }
        its(:bedrooms) { should == 2.0 }
        its(:bathrooms) { should == 1.1 }
        its(:avg_square_feet) { should == 1147 }
        its(:min_market_rent) { should == 1019 }
        its(:max_market_rent) { should == 1054 }
        its(:min_concession) { should == 500 }
        its(:max_concession) { should == 500 }
        its(:min_final_rent) { should == 1061 }
        its(:max_final_rent) { should == 1096 }
      end

      describe "the last summary" do
        subject { rent_summaries.last }

        its(:external_property_id) { should == external_property_id }
        its(:effective_date) { should == effective_date }
        its(:floor_plan_name) { should == 'Luxury' }
        its(:unit_type) { should == '3b3ba' }
        its(:bedrooms) { should == 3.0 }
        its(:bathrooms) { should == 3.0 }
        its(:avg_square_feet) { should == 1564 }
        its(:min_market_rent) { should == 1291 }
        its(:max_market_rent) { should == 1339 }
        its(:min_concession) { should == 250 }
        its(:max_concession) { should == 750 }
        its(:min_final_rent) { should == 1332 }
        its(:max_final_rent) { should == 1381 }
        its(:floor_plan_description) { should == 'big' }

        describe "concession_type" do
          subject { rent_summaries.last.concession_type }

          it { should be }
          it { should have_key(:my_field) }
          its([:my_field]) { should == '99' }
        end
      end
    end

    # Validation
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'

    # Error handling
    it_should_behave_like 'a fault handler', :get_rent_summary
  end

  it { should respond_to(:get_available_units) }

  describe "#get_available_units" do
    before { savon.stubs(:get_available_units).returns(nil) }

    subject { available_floor_plans }
    let(:available_floor_plans) { test_object.get_available_units(external_property_id) }

    it "should retrieve the data from the service" do
      savon.expects(:get_available_units).
        with(:request => {:client_name => client_name, :external_property_id => external_property_id}).
        returns(:no_floor_plans)
      subject.should be
    end

    context "with no floor plans" do
      before { savon.stubs(:get_available_units).returns(:no_floor_plans) }

      it { should be_empty }
    end

    context "with one floor plan" do
      before { savon.stubs(:get_available_units).returns(:single_floor_plan) }

      describe "the first floor plan" do
        subject { floor_plan }
        let(:floor_plan) { available_floor_plans.first }

        its(:external_property_id) { should == '42' }
        its(:effective_date) { should == Date.civil(2011, 3, 13) }
        its(:floor_plan_name) { should == 'my_floor_plan' }
        its(:bedrooms) { should == 2.0 }
        its(:bathrooms) { should == 2.0 }
        its(:square_feet) { should == 1161 }

        describe "units" do
          subject { available_units }
          let(:available_units) { floor_plan.units }

          it { should be }
          it { should have(1).available_unit }

          describe "#first" do
            subject { available_units.first }

            its(:unit_type) { should == '2b2ba' }
            its(:unit_number) { should == '112358' }
            its(:status) { should == :on_notice }
            its(:date_available) { should == Date.civil(2011, 4, 1) }
            its(:base_final_rent) { should == 1054 }
            its(:best_lease_term) { should == 14 }
            its(:best_market_rent) { should == 1079 }
            its(:best_concession) { should == 583 }
            its(:best_final_rent) { should == 1038 }
          end
        end
      end
    end

    context "with multiple floor plans" do
      before { savon.stubs(:get_available_units).returns(:multiple_floor_plans) }

      let(:external_property_id) { '42' }
      let(:effective_date) { Date.civil(2011, 3, 15) }

      describe "the first floor plan" do
        subject { available_floor_plans.first }

        its(:external_property_id) { should == external_property_id }
        its(:effective_date) { should == effective_date }
        its(:floor_plan_name) { should == '1B1B-D' }
        its(:bedrooms) { should == 1.0 }
        its(:bathrooms) { should == 1.0 }
        its(:square_feet) { should == 874 }
        its(:units) { should be_empty }
      end

      describe "the last floor plan" do
        subject { floor_plan }
        let(:floor_plan) { available_floor_plans.last }

        its(:external_property_id) { should == external_property_id }
        its(:effective_date) { should == effective_date }
        its(:floor_plan_name) { should == '1B1B' }
        its(:bedrooms) { should == 1.0 }
        its(:bathrooms) { should == 1.0 }
        its(:square_feet) { should == 666 }

        describe "units" do
          subject { available_units }
          let(:available_units) { floor_plan.units }

          it { should have(2).units }

          describe "#first" do
            subject { unit }
            let(:unit) { available_units.first }

            its(:building) { should == '99' }
            its(:unit_type) { should == '1b1ba-r' }
            its(:unit_number) { should == '11235' }

            describe "features" do
              subject { unit.features }

              it { should have(2).features }
              its(:first) { should == '50 Base Rent Adjustment' }
              its(:last) { should == '2nd Floor' }
            end

            its(:status) { should == :new_unit }
            its(:date_available) { should == Date.civil(2011, 5, 11) }
            its(:base_market_rent) { should == 710 }
            its(:base_concession) { should == 500 }
            its(:base_final_rent) { should == 669 }
            its(:best_lease_term) { should == 15 }
            its(:best_market_rent) { should == 699 }
            its(:best_concession) { should == 625 }
            its(:best_final_rent) { should == 658 }
          end

          describe "#last" do
            subject { unit }
            let(:unit) { available_units.last }

            its(:unit_type) { should == '1b1ba' }
            its(:unit_number) { should == '81321' }

            describe "features" do
              subject { unit.features }

              it { should have(1).feature }
              its(:first) { should == '1st floor' }
            end

            its(:status) { should == :vacant }
            its(:date_available) { should == Date.civil(2011, 3, 7) }
            its(:base_market_rent) { should == 732 }
            its(:base_concession) { should == 500 }
            its(:base_final_rent) { should == 690 }
            its(:best_lease_term) { should == 15 }
            its(:best_market_rent) { should == 719 }
            its(:best_concession) { should == 625 }
            its(:best_final_rent) { should == 678 }
          end
        end
      end
    end

    # Validation 
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'

    # Error handling
    it_should_behave_like 'a fault handler', :get_available_units
  end
end
