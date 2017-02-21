module YieldStarClient
  module GetAvailableUnits
    class Response < BaseResponse

      def available_units
        return @available_units if @available_units

        available_unit_hashes = extract_available_unit_hashes_from(@soap_response.to_hash)

        @available_units = available_unit_hashes.map do |hash|
          AvailableUnit.new(hash)
        end
      end

      private

      def extract_available_unit_hashes_from(soap_response)
        return_data = soap_response[:get_available_units_response][:return]
        floor_plan_hashes = [return_data[:floor_plan]].flatten.compact

        floor_plan_hashes.map do |floor_plan_hash|
          [floor_plan_hash[:unit]]
        end.flatten
      end

    end
  end
end
