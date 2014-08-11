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

    let(:fault) do
      double(
        Savon::SOAPFault,
        to_hash: {
          fault: {
            faultstring: faultstring,
            faultcode: faultcode,
            detail: {
              fault_type => {
                message: faultstring,
                code: faultcode,
              },
            }
          }
        }
      )
    end
    
    context "for an authentication fault" do
      # let(:response) { mock() { stubs(:body).returns(Savon::Spec::Fixture[:faults, :authentication_fault]) } }
      let(:faultstring) {"Client [foo] not found for this user [12e7e719764-21c]"}
      let(:faultcode) { "12e7e719764-21c" }
      let(:fault_type) { :authentication_fault }

      it { should be_a YieldStarClient::AuthenticationError }

      it "has the correct message" do
        expect(subject.message).to eq faultstring
      end

      it "has the correct code" do
        expect(subject.code).to eq faultcode
      end
    end

    context "for an internal error fault" do
      let(:faultstring) {'Internal error [12e7cfbb782-37a]'}
      let(:faultcode) { '12e7cfbb782-37a' }
      let(:fault_type) { :internal_error_fault }

      it { should be_a YieldStarClient::InternalError }

      it "has the correct message" do
        expect(subject.message).to eq faultstring
      end

      it "has the correct message" do
        expect(subject.code).to eq faultcode
      end
    end

    context "for an operation fault" do
      let(:faultstring) {'Internal error [12e7cfbb782-37a]'}
      let(:faultcode) { '12e7cfbb782-37a' }
      let(:fault_type) { :operation_fault }

      it { should be_a YieldStarClient::OperationError }

      it "has the correct message" do
        expect(subject.message).to eq faultstring
      end

      it "has the correct code" do
        expect(subject.code).to eq faultcode
      end
    end

    context "for a generic fault" do
      let(:faultstring) {'java.lang.NullPointerException'}
      let(:faultcode) { 'S:Server' }
      let(:fault_type) { :operation_fault }

      it { should be_a YieldStarClient::ServerError }

      it "has the correct message" do
        expect(subject.message).to eq faultstring
      end

      it "has the correct code" do
        expect(subject.code).to eq faultcode
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
