require 'spec_helper'

# expects the following let/helpers to be defined:
# - soap_action
# - authentication_message
# - authentication_code
# - internal_message
# - internal_code
# - operation_message
# - operation_code
# - generic_message
# - generic_code
# TODO: shared savon fixtures to cut down on the number of required let statements?
shared_examples_for "a fault handler" do
  context "when there is an authentication fault" do
    before { savon.stubs(soap_action).returns(:authentication_fault) }

    it "should raise a YieldStarClient authentication error" do
      expect { subject }.to raise_error(YieldStarClient::AuthenticationError)
    end

    it "should include the fault message in the error object" do
      expect { subject }.to raise_error { |e| e.message.should == authentication_message }
    end

    it "should include the fault code in the error object" do
      expect { subject }.to raise_error { |e| e.code.should == authentication_code }
    end
  end

  context "when there is an internal error fault" do
    before { savon.stubs(soap_action).returns(:internal_error_fault) }

    it "should raise a YieldStarClient internal error" do
      expect { subject }.to raise_error(YieldStarClient::InternalError)
    end

    it "should include the fault message in the error object" do
      expect { subject }.to raise_error { |e| e.message.should == internal_message }
    end

    it "should include the fault code in the error object" do
      expect { subject }.to raise_error { |e| e.code.should == internal_code }
    end
  end

  context "when there is an operation fault" do
    before { savon.stubs(soap_action).returns(:operation_fault) }

    it "should raise a YieldStarClient operation error" do
      expect { subject }.to raise_error(YieldStarClient::OperationError)
    end

    it "should include the fault message in the error object" do
      expect { subject }.to raise_error { |e| e.message.should == operation_message }
    end

    it "should include the fault code in the error object" do
      expect { subject }.to raise_error { |e| e.code.should == operation_code }
    end
  end

  context "when there is a generic fault" do
    before { savon.stubs(soap_action).returns(:generic_fault) }

    it "should raise a YieldStarClient server error" do
      expect { subject }.to raise_error(YieldStarClient::ServerError)
    end

    it "should include the fault message in the error object" do
      expect { subject }.to raise_error { |e| e.message.should == generic_message }
    end

    it "should include the fault code in the error object" do
      expect { subject }.to raise_error { |e| e.code.should == generic_code }
    end
  end
end

