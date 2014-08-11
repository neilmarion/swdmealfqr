module YieldStarClient
  class ExtractRentSummaryHashes

    def self.execute(response)
      return_data = response[:get_rent_summary_response][:return]
      floor_plan_unit_types = return_data[:floor_plan_unit_type]
      floor_plan_unit_types = [floor_plan_unit_types].flatten.compact

      common_properties = return_data.
        slice(:external_property_id, :effective_date)

      floor_plan_unit_types.map { |hash| common_properties.merge(hash) }
    end

  end
end
