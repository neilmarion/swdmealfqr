module YieldStarClient
  class FloorPlan

    include ::Virtus.model

    attribute :external_property_id, String
    attribute :effective_date, Date
    attribute :floor_plan_name, String
    attribute :bedrooms, Float
    attribute :bathrooms, Float
    attribute :square_feet, Integer
    attribute :units, Array
    attribute :id, String
    attribute :name, String
    attribute :starting_rate, Integer
    attribute :ending_rate, Integer

    def self.new_from_rent_summary_hash(hash)
      floorplan_id = hash.delete(:unit_type)
      starting_rate = hash.delete(:min_market_rent)
      ending_rate = hash.delete(:max_market_rent)
      square_feet = hash.delete(:avg_sq_ft)
      bedrooms = hash.delete(:bed_rooms)
      bathrooms = hash.delete(:bath_rooms)

      new(
        hash.merge(
          id: floorplan_id,
          name: floorplan_id,
          starting_rate: starting_rate,
          ending_rate: ending_rate,
          square_feet: square_feet,
          bedrooms: bedrooms,
          bathrooms: bathrooms
        )
      )
    end

  end

end
