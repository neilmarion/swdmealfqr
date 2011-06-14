require 'spec_helper'

describe "validations" do
  subject { validator }
  let(:validator) { Class.new { extend YieldStarClient::Validations } }

  it { should respond_to(:validate_required) }

  describe "#validate_client_name!" do
    subject { validator.validate_client_name!(client_name) }
    it_should_behave_like "a client_name validator"
  end

  describe "#validate_external_property_id!" do
    subject { validator.validate_external_property_id!(external_property_id) }
    it_should_behave_like "an external_property_id validator"
  end
end
