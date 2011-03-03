require 'spec_helper'

# @param param_name [Symbol] the name of the parameter to be validated
# @param max_length [Integer] the maximum allowable length
#
# Assumes subject has been preconfigured to use a let() helper method
# that matches param_name
shared_examples_for 'a string validator' do |param_name, max_length|
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
