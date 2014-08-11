module YieldStarClient
  module GetUnit
    class Response < BaseResponse

      def unit
        return @unit if @unit
        return_data = @soap_response.to_hash[:get_unit_response][:return]
        unit_data = return_data[:unit]
        @unit = Unit.new(unit_data)
      end

    end
  end
end
