require "spec_helper"

module YieldStarClient
  describe BaseResponse do

    describe "initialize" do
      it "sets @soap_response" do
        soap_response = "foo"
        response = BaseResponse.new(soap_response)
        expect(response.instance_variable_get("@soap_response")).
          to eq soap_response
      end
    end

  end
end
