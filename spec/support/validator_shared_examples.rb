require 'spec_helper'

shared_examples_for "a client_name validator" do
  it_should_behave_like "a required string validator", :client_name
  it_should_behave_like "a string length validator", :client_name, 16
end

shared_examples_for "an external_property_id validator" do
  it_should_behave_like "a required string validator", :external_property_id
  it_should_behave_like "a string length validator", :external_property_id, 50
end

shared_examples_for 'a required string validator' do |param_name|
  context "when #{param_name} is nil" do
    let(param_name) { nil }

    it "should raise an ArgumentError" do
      expect { subject }.to raise_error(ArgumentError)
    end

    it "should indicate the error is related to the #{param_name}" do
      expect { subject }.to raise_error { |e| e.message.should match(/#{param_name}/i) }
    end
  end

  context "when #{param_name} is blank" do
    let(param_name) { '        ' }

    it "should raise an ArgumentError" do
      expect { subject }.to raise_error(ArgumentError)
    end

    it "should indicate the error is related to the #{param_name}" do
      expect { subject }.to raise_error { |e| e.message.should match(/#{param_name}/i) }
    end
  end
end

shared_examples_for 'a string length validator' do |param_name, max_length|
  context "when #{param_name} is too long" do
    let(param_name) { "foo" * max_length }

    it "should raise an ArgumentError" do
      expect { subject }.to raise_error(ArgumentError)
    end

    it "should indicate the error is related to the #{param_name}" do
      expect { subject }.to raise_error { |e| e.message.should match(/#{param_name}/i) }
    end
  end
end

shared_examples_for 'an integer validator' do |param_name|
  context "when #{param_name} cannot be cast to an int" do
    let(param_name) { 'forty-two' }

    it "should raise an ArgumentError" do
      expect { subject }.to raise_error(ArgumentError)
    end

    it "should indicate the error is related to the #{param_name}" do
      expect { subject }.to raise_error { |e| e.message.should match(/#{param_name}/i) }
    end
  end
end

shared_examples_for 'a date validator' do |param_name|
  context "when #{param_name} cannot be converted to a date" do
    let(param_name) { 'foo' }

    it "should raise an ArgumentError" do
      expect { subject }.to raise_error(ArgumentError)
    end

    it "should indicate the error is related to the #{param_name}" do
      expect { subject }.to raise_error { |e| e.message.should match(/#{param_name}/i) }
    end
  end
end
