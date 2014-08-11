module YieldStarClient
  module GetFloorPlan
    class Response < BaseResponse

      def floor_plan
        return @floor_plan if @floor_plan
        return_data = @soap_response.to_hash[:get_floor_plan_response][:return]
        @floor_plan = FloorPlan.new(return_data[:floor_plan])
      end

    end
  end
end
