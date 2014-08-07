module YieldStarClient
  module GetPropertyParameters
    class Request < BaseRequest

      SOAP_ACTION = :get_property_parameters

      attribute :external_property_id, String

      validates :external_property_id, presence: true, length: {maximum: 50}

    end
  end
end
