module YieldStarClient
  class ExtractAvailableFloorPlanHashes

    def self.execute(response_hash)
      return_data = response_hash[:get_available_units_response][:return]
      common_args = return_data.slice(:external_property_id, :effective_date)
      floor_plan_hashes = [return_data[:floor_plan]].flatten.compact
      floor_plan_hashes.map do |floor_plan_hash|
        common_args.merge(floor_plan_hash)
      end
    end

  end
end
