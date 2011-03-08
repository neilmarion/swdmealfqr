require 'spec_helper'
require 'base_model'

describe YieldStarClient::BaseModel do
  describe ".property" do
    before { model_class.property(:test_property, options) }

    subject { model }

    let(:model_class) { Class.new(YieldStarClient::BaseModel) }
    let(:model) { model_class.new(:test_property => value) }

    context "when :type => Integer" do
      let(:options) { {:type => Integer} }

      context "with valid string value" do
        let(:value) { '42' }

        its(:test_property) { should be_an Integer }
        its(:test_property) { should == 42 }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with int value" do
        let(:value) { 42 }

        its(:test_property) { should be_an Integer }
        its(:test_property) { should == 42 }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with float value" do
        let(:value) { 42.5 }

        its(:test_property) { should be_an Integer }
        its(:test_property) { should == 42 }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with value that can't be translated" do
        let(:value) { [42] }

        its(:test_property) { should == value }
        its(:raw_test_property) { should == value }

        it "should raise an error when invoked via the bang method" do
          expect { subject.test_property! }.to raise_error
        end
      end

      context "with nil" do
        let(:value) { nil }

        its(:test_property) { should be_nil }
        its(:raw_test_property) { should be_nil }
        
        it "should raise an error when invoked via the bang method" do
          expect { subject.test_property! }.to raise_error
        end
      end
    end

    context "when :type => Float" do
      let(:options) { {:type => Float} }

      context "with valid string value" do
        let(:value) { '42.5' }

        its(:test_property) { should be_a Float }
        its(:test_property) { should == 42.5 }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with int value" do
        let(:value) { 42 }

        its(:test_property) { should be_a Float }
        its(:test_property) { should == 42.0 }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with float value" do
        let(:value) { 42.5 }

        its(:test_property) { should be_an Float }
        its(:test_property) { should == 42.5 }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with value that can't be translated" do
        let(:value) { 'forty-two' }

        its(:test_property) { should be_a String } 
        its(:test_property) { should == 'forty-two' }
        its(:raw_test_property) { should == value }

        it "should raise an error when invoked via the bang method" do
          expect { subject.test_property! }.to raise_error
        end
      end

      context "with nil" do
        let(:value) { nil }

        its(:test_property) { should be_nil }
        its(:raw_test_property) { should be_nil }

        it "should raise an error when invoked via the bang method" do
          expect { subject.test_property! }.to raise_error
        end
      end
    end

    context "when :type => Array" do
      let(:options) { {:type => Array} }

      context "with a type that supports to_a" do
        let(:value) { {:foo => 'bar'} }

        its(:test_property) { should be_an Array }
        its(:test_property) { should == value.to_a }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with an Array" do
        let(:value) { ['a','b'] }

        its(:test_property) { should be_an Array }
        its(:test_property) { should == value }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with nil" do
        let(:value) { nil }

        its(:test_property) { should be_an Array }
        its(:test_property) { should be_empty }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should be_nil }
      end

      context "with a value that can't be directly translated" do
        let(:value) { 'foo' }

        its(:test_property) { should be_an Array }
        its(:test_property) { should == [value] }
        its(:raw_test_property) { should == value }
        its(:test_property!) { should == model.test_property }
      end
    end

    context "when :type => String" do
      let(:options) { {:type => String} }

      context "with a string value" do
        let(:value) { '42.5' }

        its(:test_property) { should be_a String }
        its(:test_property) { should == '42.5' }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with int value" do
        let(:value) { 42 }

        its(:test_property) { should be_a String }
        its(:test_property) { should == '42' }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with float value" do
        let(:value) { 42.5 }

        its(:test_property) { should be_a String }
        its(:test_property) { should == '42.5' }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with an array value" do
        let(:value) { ['a',42,Hash.new] }

        its(:test_property) { should be_a String } 
        its(:test_property) { should == '["a", 42, {}]' }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with nil" do
        let(:value) { nil }

        its(:test_property) { should be_a String }
        its(:test_property) { should be_empty }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should be_nil }
      end
    end

    context "when :type => Date" do
      let(:options) { {:type => Date} }

      context "with a valid string" do
        let(:value) { '2011-03-10' }

        its(:test_property) { should be_a Date }
        its(:test_property) { should == Date.new(2011, 3, 10) }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with a date" do
        let(:value) { Date.new(2011, 4, 1) }

        its(:test_property) { should be_a Date }
        its(:test_property) { should == value }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with a value that can't be translated" do
        let(:value) { 'foo' }

        its(:test_property) { should == value }
        its(:raw_test_property) { should == value }

        it "should raise an error when invoked via the bang method" do
          expect { subject.test_property! }.to raise_error
        end
      end

      context "with nil" do
        let(:value) { nil }

        its(:test_property) { should be_nil }
        its(:raw_test_property) { should be_nil }

        it "should raise an error when invoked bia the bang method" do
          expect { subject.test_property! }.to raise_error
        end
      end
    end

    context "when :type => Symbol" do
      let(:options) { {:type => Symbol} }

      context "with single-word string" do
        let(:value) { 'Testing' }

        its(:test_property) { should be_a Symbol }
        its(:test_property) { should == :testing }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with multi-word string" do
        let(:value) { 'tESTing             A Sentence' }

        its(:test_property) { should be_a Symbol }
        its(:test_property) { should == :testing_a_sentence }
        its(:test_property!) { should == model.test_property }
        its(:raw_test_property) { should == value }
      end

      context "with symbol" do
        let(:value) { :testing_symbol }

        its(:test_property) { should be_a Symbol }
        its(:test_property) { should == value }
        its(:test_property!) { should == value }
        its(:raw_test_property) { should == value }
      end

      context "with value that cannot be translated" do
        let(:value) { [42] }

        its(:test_property) { should_not be_a Symbol }
        its(:test_property) { should == value }
        its(:raw_test_property) { should == value }

        it "should raise an error when invoked via the bang method" do
          expect { subject.test_property! }.to raise_error
        end
      end

      context "with nil" do
        let(:value) { nil }

        its(:test_property) { should be_nil }
        its(:raw_test_property) { should be_nil }

        it "should raise an error when invoked via the bang method" do
          expect { subject.test_property! }.to raise_error
        end
      end
    end

    context "without a type" do
      let(:options) { Hash.new }

      context "with a string value" do
        let(:value) { '42.5' }

        its(:test_property) { should == value }
        it { should_not respond_to(:test_property!) }
        it { should_not respond_to(:raw_test_property) }
      end

      context "with int value" do
        let(:value) { 42 }

        its(:test_property) { should == value }
        it { should_not respond_to(:test_property!) }
        it { should_not respond_to(:raw_test_property) }
      end

      context "with float value" do
        let(:value) { 42.5 }

        its(:test_property) { should == value }
        it { should_not respond_to(:test_property!) }
        it { should_not respond_to(:raw_test_property) }
      end

      context "with an array value" do
        let(:value) { ['forty-two',42,Hash.new] }

        its(:test_property) { should == value }
        it { should_not respond_to(:test_property!) }
        it { should_not respond_to(:raw_test_property) }
      end

      context "with nil" do
        let(:value) { nil }

        its(:test_property) { should be_nil }
        it { should_not respond_to(:test_property!) }
        it { should_not respond_to(:raw_test_property) }
      end
    end
  end
end
