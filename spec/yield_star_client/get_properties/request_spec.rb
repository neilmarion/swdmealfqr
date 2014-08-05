require "spec_helper"

module YieldStarClient
  module GetProperties
    describe Request do

      it "has the correct SOAP_ACTION" do
        expect(described_class::SOAP_ACTION).to eq :get_properties
      end

    end
  end
end
