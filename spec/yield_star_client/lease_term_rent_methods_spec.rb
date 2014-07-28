require 'spec_helper'

shared_examples_for 'a lease_term_rent service caller' do |soap_action|
  let(:unit_number) { '112358' }

  context "without options" do
    it "should retrieve the data from the service" do
      savon.expects(soap_action).
        with(:request => {:client_name => client_name, 
                          :external_property_id => external_property_id,
                          :lease_term_rent_unit_request => {:unit_number => unit_number}}).
        returns(:no_rates)
      subject.should be
    end

    # Validation
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'
    it_should_behave_like 'a required string validator', :unit_number

    # Error handling
    it_should_behave_like 'a fault handler', soap_action
  end

  context "with options" do
    let(:opts) { {:building => building, 
                  :min_lease_term => min_lease_term, 
                  :max_lease_term => max_lease_term,
                  :first_move_in_date => first_move_in_date,
                  :last_move_in_date => last_move_in_date,
                  :ready_for_move_in_date => ready_for_move_in_date,
                  :unit_available_date => unit_available_date} }

    let(:building) { '123' }
    let(:min_lease_term) { 1 }
    let(:max_lease_term) { '12' }
    let(:first_move_in_date) { '2011-03-10' }
    let(:last_move_in_date) { Date.civil(2011, 4, 1) }
    let(:ready_for_move_in_date) { '2011-03-15' }
    let(:unit_available_date) { DateTime.civil(2011, 3, 10) }

    let(:soap_body) { {:request => {:client_name => client_name,
                                    :external_property_id => external_property_id,
                                    :lease_term_rent_unit_request => request_options}} }

    let(:valid_request_options) { {:building => '123',
                                   :unit_number => unit_number,
                                   :min_lease_term => '1',
                                   :max_lease_term => '12',
                                   :first_move_in_date => '2011-03-10',
                                   :last_move_in_date => '2011-04-01',
                                   :ready_for_move_in_date => '2011-03-15',
                                   :unit_available_date => '2011-03-10'} }

    context "when all options are present and valid" do
      let(:request_options) { valid_request_options }

      it "should retrieve the data from the service" do
        savon.expects(soap_action).with(soap_body).returns(:no_rates)
        subject.should be
      end
    end

    # Validation
    it_should_behave_like 'a client_name validator'
    it_should_behave_like 'an external_property_id validator'
    it_should_behave_like 'a required string validator', :unit_number

    it_should_behave_like 'an integer validator', :min_lease_term 
    it_should_behave_like 'an integer validator', :max_lease_term
    it_should_behave_like 'a date validator', :first_move_in_date
    it_should_behave_like 'a date validator', :last_move_in_date
    it_should_behave_like 'a date validator', :ready_for_move_in_date
    it_should_behave_like 'a date validator', :unit_available_date

    # Error handling
    it_should_behave_like 'a fault handler', soap_action
  end
end

describe "lease term rent methods" do
  subject { test_object } 
  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint', :client_name => client_name) }

  let(:client_name) { 'my_client' }
  let(:external_property_id) { '42' }
  let(:unit_number) { '112358' }

  it { should respond_to(:get_lease_term_rent) }

  describe "#get_lease_term_rent" do
    before { savon.stubs(:get_lease_term_rent).returns(nil) }

    subject { unit_rates }
    let(:unit_rates) { test_object.get_lease_term_rent(external_property_id, unit_number, opts) }
    let(:opts) { {} }

    it_should_behave_like 'a lease_term_rent service caller', :get_lease_term_rent

    context "when there are no unit rates" do
      before { savon.stubs(:get_lease_term_rent).returns(:no_rates) }

      it { should be }
      it { should be_empty }
    end

    context "when there is a single unit rate" do
      before { savon.stubs(:get_lease_term_rent).returns(:single_rate) }

      it "has 1 unit rate" do
        expect(subject.size).to eq 1
      end

      describe "first record" do
        subject { unit_rates.first }
 
        it "is the correct record" do
          expect(subject.external_property_id).to eq '42'
          expect(subject.unit_number).to eq '112358'
          expect(subject.building).to be_blank
          expect(subject.make_ready_date).to eq Date.civil(2011, 3, 13)
          expect(subject.lease_term).to eq 12
          expect(subject.end_date).to eq Date.civil(2012, 3, 7)
          expect(subject.market_rent).to eq 1096
          expect(subject.final_rent).to eq 1054
          expect(subject.best).to eq true
          expect(subject.move_in_date).to eq Date.civil(2011, 3, 13)
          expect(subject.total_concession).to eq 0
          expect(subject.monthly_fixed_concession).to eq 0
          expect(subject.monthly_percent_concession).to eq 0.0
          expect(subject.months_concession).to eq 0.0
          expect(subject.one_time_fixed_concession).to eq 0
        end
      end
    end

    context "when there are multiple unit rates" do
      before { savon.stubs(:get_lease_term_rent).returns(:multiple_rates) }

      it "has 2 unit rates" do
        expect(subject.size).to eq 2
      end

      describe "the first record" do
        subject { unit_rates.first }

        it "is the correct record" do
          expect(subject.external_property_id).to eq '42'
          expect(subject.unit_number).to eq '112358'
          expect(subject.building).to eq '123'
          expect(subject.make_ready_date).to eq Date.civil(2011, 3, 7)
          expect(subject.lease_term).to eq 1
          expect(subject.end_date).to eq Date.civil(2011, 7, 1)
          expect(subject.market_rent).to eq 5277
          expect(subject.final_rent).to eq 5237
          expect(subject.best).to eq true
          expect(subject.move_in_date).to eq Date.civil(2011, 6, 1)
          expect(subject.total_concession).to eq 41
          expect(subject.monthly_fixed_concession).to eq 0
          expect(subject.monthly_percent_concession).to eq 0.0
          expect(subject.months_concession).to eq 0.0
          expect(subject.one_time_fixed_concession).to eq 500
        end
      end

      describe "the second record" do
        subject { unit_rates.last }

        it "is the correct record" do
          expect(subject.external_property_id).to eq '42'
          expect(subject.unit_number).to eq '112358'
          expect(subject.building).to eq '123'
          expect(subject.make_ready_date).to eq Date.civil(2011, 3, 7)
          expect(subject.lease_term).to eq 15
          expect(subject.end_date).to eq Date.civil(2012, 8, 24)
          expect(subject.market_rent).to eq 1272
          expect(subject.final_rent).to eq 1230
          expect(subject.best).to eq false
          expect(subject.move_in_date).to eq Date.civil(2011, 6, 1)
          expect(subject.total_concession).to eq 625
          expect(subject.monthly_fixed_concession).to eq 10
          expect(subject.monthly_percent_concession).to eq 0.02
          expect(subject.months_concession).to eq 0.5
          expect(subject.one_time_fixed_concession).to eq 500
        end
      end
    end
  end

  describe "#get_lease_term_rent_plus" do
    before { savon.stubs(:get_lease_term_rent_plus).returns(nil) }

    subject { unit_rates }
    let(:unit_rates) { test_object.get_lease_term_rent_plus(external_property_id, unit_number, opts) }
    let(:opts) { {} }

    it_should_behave_like 'a lease_term_rent service caller', :get_lease_term_rent_plus

    context "when there are no unit rates" do
      before { savon.stubs(:get_lease_term_rent_plus).returns(:no_rates) }

      it { should be_empty }
    end

    context "when there is a single unit rate" do
      before { savon.stubs(:get_lease_term_rent_plus).returns(:single_rate) }

      it "has 1 unit rate" do
        expect(subject.size).to eq 1
      end

      describe "the only record" do
        subject { unit_rates.first }

        it "is the correct record" do
          expect(subject.external_property_id).to eq '42'
          expect(subject.unit_number).to eq '112358'
          expect(subject.building).to be_blank
          expect(subject.make_ready_date).to eq Date.civil(2011, 3, 23)
          expect(subject.lease_term).to eq 12
          expect(subject.end_date).to eq Date.civil(2012, 3, 24)
          expect(subject.market_rent).to eq 1149
          expect(subject.final_rent).to eq 1108
          expect(subject.best).to eq true
          expect(subject.move_in_date).to eq Date.civil(2011, 3, 23)
          expect(subject.total_concession).to eq 0
          expect(subject.monthly_fixed_concession).to eq 0
          expect(subject.monthly_percent_concession).to eq 0.0
          expect(subject.months_concession).to eq 0.0
          expect(subject.one_time_fixed_concession).to eq 0
          expect(subject.price_valid_end_date).to eq Date.civil(2011, 3, 25)
        end
      end
    end

    context "when there are multiple unit rates" do
      before { savon.stubs(:get_lease_term_rent_plus).returns(:multiple_rates) }

      it "has 2 unit rates" do
        expect(subject.size).to eq 2
      end

      describe "the first record" do
        subject { unit_rates.first }

        it "is the correct record" do
          expect(subject.external_property_id).to eq '42'
          expect(subject.unit_number).to eq '112358'
          expect(subject.building).to eq '123'
          expect(subject.make_ready_date).to eq Date.civil(2011, 3, 23)
          expect(subject.lease_term).to eq 6
          expect(subject.end_date).to eq Date.civil(2011, 9, 28)
          expect(subject.market_rent).to eq 1249
          expect(subject.final_rent).to eq 1207
          expect(subject.best).to eq true
          expect(subject.move_in_date).to eq Date.civil(2011, 4, 1)
          expect(subject.total_concession).to eq 250
          expect(subject.monthly_fixed_concession).to eq 0
          expect(subject.monthly_percent_concession).to eq 0.0
          expect(subject.months_concession).to eq 0.0
          expect(subject.one_time_fixed_concession).to eq 500
          expect(subject.price_valid_end_date).to eq Date.civil(2011, 4, 3)
        end
      end

      describe "the second record" do
        subject { unit_rates.last }

        it "is the correct record" do
          expect(subject.external_property_id).to eq '42'
          expect(subject.unit_number).to eq '112358'
          expect(subject.building).to eq '123'
          expect(subject.make_ready_date).to eq Date.civil(2011, 3, 23)
          expect(subject.lease_term).to eq 12
          expect(subject.end_date).to eq Date.civil(2012, 3, 26)
          expect(subject.market_rent).to eq 1176
          expect(subject.final_rent).to eq 1135
          expect(subject.best).to eq false
          expect(subject.move_in_date).to eq Date.civil(2011, 4, 1)
          expect(subject.total_concession).to eq 500
          expect(subject.monthly_fixed_concession).to eq 11
          expect(subject.monthly_percent_concession).to eq 0.02
          expect(subject.months_concession).to eq 2.0
          expect(subject.one_time_fixed_concession).to eq 500
          expect(subject.price_valid_end_date).to eq Date.civil(2011, 4, 3)
        end
      end
    end
  end

  describe "#get_renewal_lease_term_rent" do
    before { savon.stubs(:get_renewal_lease_term_rent).returns(nil) }

    subject { unit_rates }
    let(:unit_rates) { test_object.get_renewal_lease_term_rent(external_property_id, unit_number, opts) }

    let(:opts) { Hash.new }

    context "without options" do
      it "should retrieve the data from the service" do
        savon.expects(:get_renewal_lease_term_rent).
          with(:request => {:client_name => client_name, 
                            :external_property_id => external_property_id, 
                            :renewal_lease_term_rent_unit_request => {:unit_number => unit_number}}).
          returns(:no_rates)
        subject.should be
      end

      # Validation
      it_should_behave_like 'a client_name validator'
      it_should_behave_like 'an external_property_id validator'
      it_should_behave_like 'a required string validator', :unit_number

      # Error handling
      it_should_behave_like 'a fault handler', :get_renewal_lease_term_rent
    end

    context "with options" do
      let(:opts) { {:building => building,
                    :min_lease_term => min_lease_term,
                    :max_lease_term => max_lease_term,
                    :start_date => start_date} }

      let(:building) { '123' }
      let(:min_lease_term) { 6 }
      let(:max_lease_term) { 12 }
      let(:start_date) { '2011-03-10' }

      it "should retrieve the data from the service" do
        savon.expects(:get_renewal_lease_term_rent).
          with(:request => {:client_name => client_name,
                            :external_property_id => external_property_id,
                            :renewal_lease_term_rent_unit_request => {:unit_number => unit_number,
                                                                      :building => building.to_s,
                                                                      :min_lease_term => min_lease_term.to_s,
                                                                      :max_lease_term => max_lease_term.to_s,
                                                                      :start_date => start_date.to_s}}).
          returns(:no_rates)
        subject.should be
      end

      # Validation
      it_should_behave_like 'a client_name validator'
      it_should_behave_like 'an external_property_id validator'
      it_should_behave_like 'a required string validator', :unit_number
      it_should_behave_like 'an integer validator', :min_lease_term
      it_should_behave_like 'an integer validator', :max_lease_term
      it_should_behave_like 'a date validator', :start_date

      # Error handling
      it_should_behave_like 'a fault handler', :get_renewal_lease_term_rent
    end

    context "when there are no rates" do
      before { savon.stubs(:get_renewal_lease_term_rent).returns(:no_rates) }

      it { should be_empty }
    end

    context "when there is a single rate" do
      before { savon.stubs(:get_renewal_lease_term_rent).returns(:single_rate) }

      it "has 1 unit rate" do
        expect(subject.size).to eq 1
      end

      describe "the only record" do
        subject { unit_rates.first }

        it "is the correct record" do
          expect(subject.external_property_id).to eq external_property_id
          expect(subject.unit_number).to eq unit_number
          expect(subject.building).to eq '123'
          expect(subject.lease_term).to eq 12
          expect(subject.end_date).to eq Date.civil(2012, 10, 26)
          expect(subject.market_rent).to eq 1086
          expect(subject.final_rent).to eq 1086
          expect(subject.best).to eq true
        end
      end
    end

    context "when there are multiple rates" do
      before { savon.stubs(:get_renewal_lease_term_rent).returns(:multiple_rates) }

      it "has 2 unit rates" do
        expect(subject.size).to eq 2
      end

      describe "the first record" do
        subject { unit_rates.first }

        it "is the correct record" do
          expect(subject.external_property_id).to eq external_property_id
          expect(subject.unit_number).to eq unit_number
          expect(subject.start_date).to eq Date.civil(2011, 10, 24)
          expect(subject.lease_term).to eq 1
          expect(subject.end_date).to eq Date.civil(2011, 11, 24)
          expect(subject.market_rent).to eq 1331
          expect(subject.final_rent).to eq 1300
          expect(subject.best).to eq true
        end
      end

      describe "the second record" do
        subject { unit_rates.last }

        it "is the correct record" do
          expect(subject.external_property_id).to eq external_property_id
          expect(subject.unit_number).to eq unit_number
          expect(subject.start_date).to eq Date.civil(2011, 10, 24)
          expect(subject.lease_term).to eq 12
          expect(subject.end_date).to eq Date.civil(2012, 10, 26)
          expect(subject.market_rent).to eq 1086
          expect(subject.final_rent).to eq 1086
          expect(subject.best).to eq false
        end
      end
    end
  end
end
