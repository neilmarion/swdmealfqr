module YieldStarClient
  module GetPropertyParameters
    class Response

      def initialize(soap_response)
        @soap_response = soap_response
      end

      def property_parameters
        return @property_parameters if @property_parameters
        @property_parameters = @soap_response.
          to_hash[:get_property_parameters_response]\
          [:return]
        @property_parameters = PropertyParameters.new_from(@property_parameters)
      end

    end
  end
end
