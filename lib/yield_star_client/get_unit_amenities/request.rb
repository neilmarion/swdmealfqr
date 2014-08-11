module YieldStarClient
  module GetUnitAmenities
    class Request < BaseRequest

      SOAP_ACTION = :get_unit_amenities

      attribute :external_property_id, String
      attribute :unit_name, String
      attribute :building, String

      validates :external_property_id, presence: true, length: {maximum: 50}
      validates :unit_name, presence: true

    end
  end
end
