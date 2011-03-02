require 'spec_helper'
require 'errors'

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
