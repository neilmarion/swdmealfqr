module YieldStarClient
  module GetUnits
    class Response < BaseResponse

      def units
        return @units if @units
        return_data = @soap_response.to_hash[:get_units_response][:return]
        unit_hashes = [return_data[:unit]].flatten.compact
        @units = unit_hashes.map { |hash| Unit.new(hash) }
      end

    end
  end
end
