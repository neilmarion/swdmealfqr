require 'spec_helper'

describe YieldStarClient::ServerError do
  subject { error }
  let(:error) { YieldStarClient::ServerError.new(message, code) }
  let(:code) { 'my code' }
  let(:message) { 'my message' }

  context "default initialization" do
    let(:error) { YieldStarClient::ServerError.new }

    it { should respond_to(:code) }
    its(:code) { should_not be }

    it { should respond_to(:message) }
    its(:message) { should == error.class.name }
  end

  context "message initialization" do
    let(:error) { YieldStarClient::ServerError.new(message) }

    its(:code) { should_not be }
    its(:message) { should == message }
  end

  context "full initialization" do
    its(:code) { should == code }
    its(:message) { should == message }
  end

  describe "#to_s" do
    subject { error.to_s }

    context "when there is a message" do
      it { should match(message) }
    end

    context "when there isn't a message" do
      let(:message) { nil }
      it { should match(error.class.name) }
    end
  end

  describe ".translate_fault" do
    subject { YieldStarClient::ServerError.translate_fault(fault) }
    let(:fault) { Savon::SOAP::Fault.new(response)}
    
    context "for an authentication fault" do
      let(:response) { mock() { stubs(:body).returns(Savon::Spec::Fixture[:faults, :authentication_fault]) } }

      it { should be_a YieldStarClient::AuthenticationError }
      its(:message) { should == 'Client [foo] not found for this user [12e7e719764-21c]' }
      its(:code) { should == '12e7e719764-21c' }
    end

    context "for an internal error fault" do
      let(:response) { mock() { stubs(:body).returns(Savon::Spec::Fixture[:faults, :internal_error_fault]) } }

      it { should be_a YieldStarClient::InternalError }
      its(:message) { should == 'Internal error [12e7cfbb782-37a]' }
      its(:code) { should == '12e7cfbb782-37a' }
    end

    context "for an operation fault" do
      let(:response) { mock() { stubs(:body).returns(Savon::Spec::Fixture[:faults, :operation_fault]) } }

      it { should be_a YieldStarClient::OperationError }
      its(:message) { should == 'Invalid floor plan name null [12e7e6acc24-1b]' }
      its(:code) { should == '12e7e6acc24-1b' }
    end

    context "for a generic fault" do
      let(:response) { mock() { stubs(:body).returns(Savon::Spec::Fixture[:faults, :generic_fault]) } }

      it { should be_a YieldStarClient::ServerError }
      its(:message) { should == 'java.lang.NullPointerException' }
      its(:code) { should == 'S:Server' }
    end
  end
end

describe YieldStarClient::AuthenticationError do
  it { should be }
end

describe YieldStarClient::InternalError do
  it { should be }
end

describe YieldStarClient::OperationError do
  it { should be }
end
