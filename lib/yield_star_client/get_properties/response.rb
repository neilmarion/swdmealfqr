module YieldStarClient
  module GetProperties
    class Response

      def initialize(soap_response)
        @soap_response = soap_response
      end

      def properties
        return @properties if @properties
        @properties = @soap_response.to_hash[:get_properties_response]\
          [:return][:property]
        @properties = [@properties].flatten.compact
        @properties = @properties.map { |property| Property.new(property) }
      end

    end
  end
end
