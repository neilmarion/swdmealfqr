module YieldStarClient
  module GetUnits
    class Request < BaseRequest

      SOAP_ACTION = :get_units

      attribute :external_property_id, String
      attribute :building_name, String

      validates :external_property_id, presence: true, length: {maximum: 50}

    end
  end
end
