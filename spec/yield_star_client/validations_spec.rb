require 'spec_helper'
require 'validations'

describe "validations" do
  subject { validator }
  let(:validator) { Class.new { extend YieldStarClient::Validations } }

  it { should respond_to(:validate_required) }
  
  describe "#validate_client_name" do
    subject { validator.validate_client_name(client_name) }
    it_should_behave_like "a client_name validator"
  end

  describe "#validate_external_property_id" do
    subject { validator.validate_external_property_id(external_property_id) }
    it_should_behave_like "an external_property_id validator"
  end

  describe "#validate_required" do  
    subject { validator.validate_required(name => value) }
    let(:name) { :my_required_argument }
    
    context "when value is nil" do
      let(:value) { nil }

      it "should raise an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end

      it "should include the name in the error message" do
        expect { subject }.to raise_error { |e| e.message.should match(/#{name}/i) }
      end
    end

    context "when value is blank" do
      let(:value) { '           ' }

      it "should raise an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end

      it "should include the name in the error message" do
        expect { subject }.to raise_error { |e| e.message.should match(/#{name}/i) }
      end
    end

    context "when value is not blank" do
      let(:value) { 'valid value' }

      it "should not raise any errors" do
        expect { subject }.to_not raise_error
      end
    end
  end

  it { should respond_to(:validate_length) }

  describe "#validate_length" do
    subject { validator.validate_length(name, value, max_length) }
    let(:name) { :my_length_argument }
    let(:max_length) { 8 }

    context "when value is longer than max_length" do
      let(:value) { 'a' * (max_length + 1) }
      
      it "should raise an ArgumentError" do
        expect { subject }.to raise_error(ArgumentError)
      end

      it "should include the name in the error message" do
        expect { subject }.to raise_error { |e| e.message.should match(/#{name}/i) }
      end
    end

    context "when value is shorter than max_length" do
      let(:value) { 'a' * (max_length - 1) }
      
      it "should not raise an error" do
        expect { subject }.to_not raise_error
      end
    end

    context "when value is nil" do
      let(:value) { nil }
      
      it "should not raise an error" do
        expect { subject }.to_not raise_error
      end
    end

    context "when max_length is nil" do
      let(:max_length) { nil }
      let(:value) { 'aaaaaaaaaaa' }

      it "should not raise an error" do
        expect { subject }.to_not raise_error
      end
    end
  end
end
