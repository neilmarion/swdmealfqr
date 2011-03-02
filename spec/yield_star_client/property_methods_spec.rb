require 'spec_helper'

describe "property methods" do
  subject { test_object }
  let(:test_object) { YieldStarClient::Client.new(:endpoint => 'http://bogusendpoint') }

  it { should respond_to(:get_properties) }

  describe "#get_properties" do
    before { savon.stubs(:get_properties).returns(nil) }

    subject { properties }
    let(:properties) { test_object.get_properties(client_name) }
    let(:client_name) { 'my client name' }

    it "should retrieve the property data by client_name from the service" do
      savon.expects(:get_properties).with(:request => {:client_name => client_name}).returns(:single_property)
      subject.should be
    end

    context "with single property" do
      before { savon.stubs(:get_properties).returns(:single_property) }

      it { should have(1).property }

      describe "first property" do
        subject { properties.first }

        it { should have(2).keys }
 
        it { should have_key(:name) }
        its([:name]) { should == 'Minimal' }
 
        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '1' }
      end
    end

    context "with multiple properties" do
      before { savon.stubs(:get_properties).returns(:multiple_properties) }

      it { should have(2).properties }

      describe "first property" do
        subject { properties.first }

        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '2' }

        it { should have_key(:name) }
        its([:name]) { should == 'Typical' }

        it { should have_key(:address) }
        its([:address]) { should == '123 Address Ln' }

        it { should have_key(:city) }
        its([:city]) { should == 'Beverly Hills' }

        it { should have_key(:state) }
        its([:state]) { should == 'CA' }

        it { should have_key(:zip) }
        its([:zip]) { should == '90210' }

        it { should have_key(:longitude) }
        its([:longitude]) { should == -122.605687 }

        it { should have_key(:latitude) }
        its([:latitude]) { should == 45.544873 }

        it { should have_key(:phone) }
        its([:phone]) { should_not be }

        it { should have_key(:fax) }
        its([:fax]) { should_not be }

        it { should have_key(:year_built) }
        its([:year_built]) { should == 2009 }

        it { should_not have_key(:unit_count) }
        it { should_not have_key(:website) }
      end

      describe "last property" do
        subject { properties.last }

        it { should have_key(:external_property_id) }
        its([:external_property_id]) { should == '3' }

        it { should have_key(:name) }
        its([:name]) { should == 'Fully Loaded' }

        it { should have_key(:address) }
        its([:address]) { should == '550 NW Franklin Ave #200' }

        it { should have_key(:city) }
        its([:city]) { should == 'Bend' }

        it { should have_key(:state) }
        its([:state]) { should == 'OR' }

        it { should have_key(:zip) }
        its([:zip]) { should == '97701' }

        it { should have_key(:longitude) }
        its([:longitude]) { should == -121.313936 }

        it { should have_key(:latitude) }
        its([:latitude]) { should == 44.057411 }

        it { should have_key(:phone) }
        its([:phone]) { should == '5413063374' }

        it { should have_key(:fax) }
        its([:fax]) { should == '1234567890' }

        it { should have_key(:website) }
        its([:website]) { should == 'http://g5platform.com' }

        it { should have_key(:unit_count) }
        its([:unit_count]) { should == 100 }

        it { should have_key(:year_built) }
        its([:year_built]) { should == 2008 }
      end
    end

    describe "validation" do
      context "when client name is nil" do
        let(:client_name) { nil }

        it "should raise an error" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context "when client name is blank" do
        let(:client_name) { '       ' }

        it "should raise an error" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end

      context "when client name is long" do
        let (:client_name) { 'this is an especially long client name that should violate the max length' }

        it "should raise an error" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end

    # TODO: Refactor this into a shared example group or macro.
    # Error handling is going to be identical for almost all of the actions.
    describe "error handling" do
      context "when there is an authentication fault" do
        before { savon.stubs(:get_properties).returns(:authentication_fault) }

        it "should raise a YieldStarClient authentication error" do
          expect { subject }.to raise_error(YieldStarClient::AuthenticationError)
        end

        it "should include the fault message in the error object" do
          expect { subject }.to raise_error { |e| e.message.should == 'Client [testing] not found for this user [12e72edcd56-341]' }
        end

        it "should include the fault code in the error object" do
          expect { subject }.to raise_error { |e| e.code.should == '12e72edcd56-341' }
        end
      end

      context "when there is an internal error fault" do
        before { savon.stubs(:get_properties).returns(:internal_error_fault) }

        it "should raise a YieldStarClient internal error" do
          expect { subject }.to raise_error(YieldStarClient::InternalError)
        end

        it "should include the fault message in the error object" do
          expect { subject }.to raise_error { |e| e.message.should == 'An unexpected internal error has occurred' }
        end

        it "should include the fault code in the error object" do
          expect { subject }.to raise_error { |e| e.code.should == 'my-internal-code' }
        end
      end

      context "when there is an operation fault" do
        before { savon.stubs(:get_properties).returns(:operation_fault) }

        it "should raise a YieldStarClient operation error" do
          expect { subject }.to raise_error(YieldStarClient::OperationError)
        end

        it "should include the fault message in the error object" do
          expect { subject }.to raise_error { |e| e.message.should == 'An expected error occurred in the operation' }
        end

        it "should include the fault code in the error object" do
          expect { subject }.to raise_error { |e| e.code.should == 'my-op-code' }
        end
      end

      context "when there is a generic fault" do
        before { savon.stubs(:get_properties).returns(:generic_fault) }

        it "should raise a YieldStarClient server error" do
          expect { subject }.to raise_error(YieldStarClient::ServerError)
        end

        it "should include the fault message in the error object" do
          expect { subject }.to raise_error { |e| e.message.should == 'java.lang.NullPointerException' }
        end

        it "should include the fault code in the error object" do
          expect { subject }.to raise_error { |e| e.code.should == 'S:Server' }
        end
      end
    end
  end
end
