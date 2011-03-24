require 'spec_helper'

describe "lease term rent methods" do
  subject { test_object } 
  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint' ) }

  let(:client_name) { 'my_client' }
  let(:external_property_id) { '42' }

  it { should respond_to(:get_lease_term_rent) }

  describe "#get_lease_term_rent" do
    before { savon.stubs(:get_lease_term_rent).returns(nil) }

    subject { unit_rates }
    let(:unit_rates) { test_object.get_lease_term_rent(client_name, external_property_id, unit_number) }
    let(:unit_number) { '112358' }

    context "without options" do
      it "should retrieve the data from the service" do
        savon.expects(:get_lease_term_rent).
          with(:request => {:client_name => client_name, 
                            :external_property_id => external_property_id,
                            :unit_number => unit_number}).
          returns(:no_rates)
        subject.should be
      end

      # Validation
      it_should_behave_like 'a client_name validator'
      it_should_behave_like 'an external_property_id validator'
      it_should_behave_like 'a required string validator', :unit_number

      # Error handling
      it_should_behave_like 'a fault handler', :get_lease_term_rent
    end

    context "with options" do
      let(:unit_rates) { test_object.get_lease_term_rent(client_name, external_property_id, unit_number, opts) }
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
                                              :unit_number => unit_number,
                                              :lease_term_rent_unit_request => request_options}} }
      
      let(:valid_request_options) { {:building => '123',
                                       :min_lease_term => '1',
                                       :max_lease_term => '12',
                                       :first_move_in_date => '2011-03-10',
                                       :last_move_in_date => '2011-04-01',
                                       :ready_for_move_in_date => '2011-03-15',
                                       :unit_available_date => '2011-03-10'} }

      context "when all options are present and valid" do
        let(:request_options) { valid_request_options }

        it "should retrieve the data from the service" do
          savon.expects(:get_lease_term_rent).with(soap_body).returns(:no_rates)
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
      it_should_behave_like 'a fault handler', :get_lease_term_rent
    end

    context "when there are no unit rates" do
      before { savon.stubs(:get_lease_term_rent).returns(:no_rates) }

      it { should be }
      it { should be_empty }
    end

    context "when there is a single unit rate" do
      before { savon.stubs(:get_lease_term_rent).returns(:single_rate) }
      
      it { should have(1).unit_rate }

      describe "first record" do
        subject { unit_rates.first }
      
        its(:external_property_id) { should == '42' }
        its(:unit_number) { should == '112358' }
        its(:building) { should_not be }
        its(:make_ready_date) { should == Date.civil(2011, 3, 13) }
        its(:lease_term) { should == 12 }
        its(:end_date) { should  == Date.civil(2012, 3, 7) }
        its(:market_rent) { should == 1096 }
        its(:final_rent) { should == 1054 }
        its(:best) { should be_true }
        its(:move_in_date) { should == Date.civil(2011, 3, 13) }
        its(:total_concession) { should == 0 }
        its(:monthly_fixed_concession) { should == 0 }
        its(:monthly_percent_concession) { should == 0.0 }
        its(:months_concession) { should == 0.0 }
        its(:one_time_fixed_concession) { should == 0 }
      end
    end

    context "with multiple unit rates" do
      before { savon.stubs(:get_lease_term_rent).returns(:multiple_rates) }

      it { should have(2).unit_rates }

      describe "first record" do
        subject { unit_rates.first }

        its(:external_property_id) { should == '42' }
        its(:unit_number) { should == '112358' }
        its(:building) { should == '123' }
        its(:make_ready_date) { should == Date.civil(2011, 3, 7) }
        its(:lease_term) { should == 1 }
        its(:end_date) { should  == Date.civil(2011, 7, 1) }
        its(:market_rent) { should == 5277 }
        its(:final_rent) { should == 5237 }
        its(:best) { should be_true }
        its(:move_in_date) { should == Date.civil(2011, 6, 1) }
        its(:total_concession) { should == 41 }
        its(:monthly_fixed_concession) { should == 0 }
        its(:monthly_percent_concession) { should == 0.0 }
        its(:months_concession) { should == 0.0 }
        its(:one_time_fixed_concession) { should == 500 }
      end

      describe "second record" do
        subject { unit_rates.last }

        its(:external_property_id) { should == '42' }
        its(:unit_number) { should == '112358' }
        its(:building) { should == '123' }
        its(:make_ready_date) { should == Date.civil(2011, 3, 7) }
        its(:lease_term) { should == 15 }
        its(:end_date) { should  == Date.civil(2012, 8, 24) }
        its(:market_rent) { should == 1272 }
        its(:final_rent) { should == 1230 }
        its(:best) { should be_false }
        its(:move_in_date) { should == Date.civil(2011, 6, 1) }
        its(:total_concession) { should == 625 }
        its(:monthly_fixed_concession) { should == 10 }
        its(:monthly_percent_concession) { should == 0.02 }
        its(:months_concession) { should == 0.5 }
        its(:one_time_fixed_concession) { should == 500 }
      end
    end
  end
end
