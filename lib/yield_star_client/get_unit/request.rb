module YieldStarClient
  module GetUnit
    class Request < BaseRequest

      SOAP_ACTION = :get_unit

      attribute :external_property_id, String
      attribute :unit, String
      attribute :building, String

      validates :external_property_id, presence: true, length: {maximum: 50}
      validates :unit, presence: true

    end
  end
end
