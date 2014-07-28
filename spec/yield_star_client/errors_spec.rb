require 'spec_helper'

describe YieldStarClient::ServerError do
  subject { error }
  let(:error) { YieldStarClient::ServerError.new(message, code) }
  let(:code) { 'my code' }
  let(:message) { 'my message' }

  context "default initialization" do
    let(:error) { YieldStarClient::ServerError.new }

    it { should respond_to(:code) }

    it "does not have a code" do
      expect(subject.code).to be_blank
    end

    it { should respond_to(:message) }

    it "has the correct message" do
      expect(subject.message).to eq error.class.name
    end
  end

  context "message initialization" do
    let(:error) { YieldStarClient::ServerError.new(message) }

    it "does not have a code" do
      expect(subject.code).to be_blank
    end

    it "has the correct message" do
      expect(subject.message).to eq message
    end
  end

  context "full initialization" do
    it "has a code" do
      expect(subject.code).to eq code
    end

    it "has the correct message" do
      expect(subject.message).to eq message
    end
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

      it "has the correct message" do
        expect(subject.message).to eq 'Client [foo] not found for this user [12e7e719764-21c]'
      end

      it "has the correct code" do
        expect(subject.code).to eq '12e7e719764-21c'
      end
    end

    context "for an internal error fault" do
      let(:response) { mock() { stubs(:body).returns(Savon::Spec::Fixture[:faults, :internal_error_fault]) } }

      it { should be_a YieldStarClient::InternalError }

      it "has the correct message" do
        expect(subject.message).to eq 'Internal error [12e7cfbb782-37a]'
      end

      it "has the correct message" do
        expect(subject.code).to eq '12e7cfbb782-37a'
      end
    end

    context "for an operation fault" do
      let(:response) { mock() { stubs(:body).returns(Savon::Spec::Fixture[:faults, :operation_fault]) } }

      it { should be_a YieldStarClient::OperationError }

      it "has the correct message" do
        expect(subject.message).to eq 'Invalid floor plan name null [12e7e6acc24-1b]'
      end

      it "has the correct code" do
        expect(subject.code).to eq '12e7e6acc24-1b'
      end
    end

    context "for a generic fault" do
      let(:response) { mock() { stubs(:body).returns(Savon::Spec::Fixture[:faults, :generic_fault]) } }

      it { should be_a YieldStarClient::ServerError }

      it "has the correct message" do
        expect(subject.message).to eq 'java.lang.NullPointerException'
      end

      it "has the correct code" do
        expect(subject.code).to eq 'S:Server'
      end
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
