module YieldStarClient
  module GetFloorPlan
    class Response < BaseResponse

      def floor_plan
        return @floor_plan if @floor_plan
        floor_plan_hash = @soap_response.to_hash[:get_floor_plan_response]\
                            [:return][:floor_plan]
        @floor_plan = FloorPlan.new(
          external_property_id: floor_plan_hash[:external_property_id],
          name: floor_plan_hash[:name],
          square_feet: floor_plan_hash[:square_footage],
          bedrooms: floor_plan_hash[:bed_rooms],
          bathrooms: floor_plan_hash[:bath_rooms]
        )
      end

    end
  end
end
