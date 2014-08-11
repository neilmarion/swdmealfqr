module YieldStarClient
  module GetFloorPlans
    class Request < BaseRequest

      SOAP_ACTION = :get_floor_plans

      attribute :external_property_id, String
      validates :external_property_id, presence: true, length: {maximum: 50}

    end
  end
end
