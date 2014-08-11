module YieldStarClient
  module GetProperty
    class Response

      def initialize(soap_response)
        @soap_response = soap_response
      end

      def property
        return @property if @property
        @property = @soap_response.to_hash[:get_property_response]\
          [:return][:property]
        @property = Property.new(@property)
      end

    end
  end
end
