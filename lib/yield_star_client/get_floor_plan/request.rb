module YieldStarClient
  module GetFloorPlan
    class Request < BaseRequest

      SOAP_ACTION = :get_floor_plan

      attribute :external_property_id, String
      attribute :floor_plan_name, String

      validates :external_property_id, presence: true, length: {maximum: 50}
      validates :floor_plan_name, presence: true

    end
  end
end
