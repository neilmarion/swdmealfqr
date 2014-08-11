require 'spec_helper'

module YieldStarClient
  describe Client do

    include Savon::SpecHelper

    let(:logger) { Logger.new("tmp/test.log") }
    let(:client_config) do
      CONFIG.merge(
        debug: true,
        logger: logger,
      )
    end

    let(:client) { described_class.new(client_config) }

    describe "#get_rent_summary" do
      it "returns the rent summaries", vcr: {record: :once} do
        rent_summaries = catch(:rent_summaries) do
          client.get_properties.each do |property|
            external_property_id = property.external_property_id
            rent_summaries = client.get_rent_summary(external_property_id)
            throw :rent_summaries, rent_summaries if rent_summaries.any?
          end
          throw :rent_summaries, [] if rent_summaries.empty?
        end

        fail "Unable to find rent summaries" if rent_summaries.empty?
        expect(rent_summaries.first).to be_a RentSummary
      end
    end

  end
end

describe "rental/availability methods" do
  subject { test_object }

  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint', :client_name => client_name) }

  let(:client_name) { 'my_client_name' }
  let(:external_property_id) { '42' }

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

        it "has the correct attributes" do
          expect(subject.external_property_id).to eq '42'
          expect(subject.effective_date).to eq Date.civil(2011, 3, 13)
          expect(subject.floor_plan_name).to eq 'my_floor_plan'
          expect(subject.bedrooms).to eq 2.0
          expect(subject.bathrooms).to eq 2.0
          expect(subject.square_feet).to eq 1161
        end

        describe "units" do
          subject { available_units }
          let(:available_units) { floor_plan.units }

          it { should be }

          it "has 1 available unit" do
            expect(subject.size).to eq 1
          end

          describe "#first" do
            subject { available_units.first }

            it "has the correct attributes" do
              expect(subject.unit_type).to eq '2b2ba'
              expect(subject.unit_number).to eq '112358'
              expect(subject.status).to eq :on_notice
              expect(subject.date_available).to eq Date.civil(2011, 4, 1)
              expect(subject.base_final_rent).to eq 1054
              expect(subject.best_lease_term).to eq 14
              expect(subject.best_market_rent).to eq 1079
              expect(subject.best_concession).to eq 583
              expect(subject.best_final_rent).to eq 1038
            end
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

        it "has the correct attributes" do
          expect(subject.external_property_id).to eq external_property_id
          expect(subject.effective_date).to eq effective_date
          expect(subject.floor_plan_name).to eq '1B1B-D'
          expect(subject.bedrooms).to eq 1.0
          expect(subject.bathrooms).to eq 1.0
          expect(subject.square_feet).to eq 874
          expect(subject.units).to be_empty
        end
      end

      describe "the last floor plan" do
        subject { floor_plan }
        let(:floor_plan) { available_floor_plans.last }

        it "has the correct attributes" do
          expect(subject.external_property_id).to eq external_property_id
          expect(subject.effective_date).to eq effective_date
          expect(subject.floor_plan_name).to eq '1B1B'
          expect(subject.bedrooms).to eq 1.0
          expect(subject.bathrooms).to eq 1.0
          expect(subject.square_feet).to eq 666
        end

        describe "units" do
          subject { available_units }
          let(:available_units) { floor_plan.units }

          it "has 2 units" do
            expect(subject.size).to eq 2
          end

          describe "#first" do
            subject { unit }
            let(:unit) { available_units.first }

            it "has the correct attributes" do
              expect(subject.building).to eq '99'
              expect(subject.unit_type).to eq '1b1ba-r'
              expect(subject.unit_number).to eq '11235'
            end

            describe "features" do
              subject { unit.features }

              it "has 2 features" do
                expect(subject.size).to eq 2
              end

              it "has the correct attributes" do
                expect(subject.first).to eq '50 Base Rent Adjustment'
                expect(subject.last).to eq '2nd Floor'
              end
            end

            it "has the correct attributes" do
              expect(subject.status).to eq :new_unit
              expect(subject.date_available).to eq Date.civil(2011, 5, 11)
              expect(subject.base_market_rent).to eq 710
              expect(subject.base_concession).to eq 500
              expect(subject.base_final_rent).to eq 669
              expect(subject.best_lease_term).to eq 15
              expect(subject.best_market_rent).to eq 699
              expect(subject.best_concession).to eq 625
              expect(subject.best_final_rent).to eq 658
            end
          end

          describe "#last" do
            subject { unit }
            let(:unit) { available_units.last }

            it "has the correct attributes" do
              expect(subject.unit_type).to eq '1b1ba'
              expect(subject.unit_number).to eq '81321'
            end

            describe "features" do
              subject { unit.features }

              it "has 1 feature" do
                expect(subject.size).to eq 1
              end

              it "has the correct attributes" do
                expect(subject.first).to eq '1st floor'
              end
            end

            it "has the correct attributes" do
              expect(subject.status).to eq :vacant
              expect(subject.date_available).to eq Date.civil(2011, 3, 7)
              expect(subject.base_market_rent).to eq 732
              expect(subject.base_concession).to eq 500
              expect(subject.base_final_rent).to eq 690
              expect(subject.best_lease_term).to eq 15
              expect(subject.best_market_rent).to eq 719
              expect(subject.best_concession).to eq 625
              expect(subject.best_final_rent).to eq 678
            end
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
