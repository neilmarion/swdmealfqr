module YieldStarClient

  # Represents a summary of rent information for a floor plan/unit type combination.
  #
  # @attr [Date] effective_date the data on which all listed prices are considered effective
  # @attr [String] external_property_id the ID of the property associated with the floor plan
  # @attr [String] floor_plan_name the floor plan that matches the Price Optimizer dashboard
  # @attr [String] unit_type the unit type for this information
  # @attr [Float] bedrooms the number of bedrooms in this unit type
  # @attr [Float] bathrooms the number of bathrooms in this unit type
  # @attr [Integer] avg_square_feet the average square footage in this unit type
  # @attr [Integer] min_market_rent the minimum market rents for the currently available units
  #                                 in this unit type
  # @attr [Integer] max_market_rent the maximum market rents for the currently available units
  #                                 in this unit type
  # @attr [Object] concession_type reserved for future use by YieldStar
  # @attr [Integer] min_concession the minimum value of any ocncessions (rent discount,
  #                                recurrent discounts currently being offtered) for
  #                                this particular unit type
  # @attr [Integer] max_concession the maximum value of any concessions (rent discounts,
  #                                recurrent discounts currently being offered) for this
  #                                particular unit type
  # @attr [Integer] min_final_rent the minimum **EFFECTIVE** rents for the currently available
  #                                units in this unit type
  # @attr [Integer] max_final_rent the maximum **EFFECTIVE** rents for the currently available
  #                                units in this unit type.
  # @attr [String] floor_plan_description the marketing name of the floor plan
  class RentSummary

    include Virtus.model

    attribute :effective_date, Date
    attribute :external_property_id, String
    attribute :floor_plan_name, String
    attribute :unit_type, String, default: ''
    attribute :bedrooms, Float
    attribute :bathrooms, Float
    attribute :avg_square_feet, Integer
    attribute :min_market_rent, Integer
    attribute :max_market_rent, Integer
    attribute :concession_type, String
    attribute :min_concession, Integer
    attribute :max_concession, Integer
    attribute :min_final_rent, Integer
    attribute :max_final_rent, Integer
    attribute :floor_plan_description, String
    attribute :bedrooms_override_from_unit_type, Float, default: lambda { |rs, attribute| self.bedrooms_override_from(rs.unit_type) }
    attribute :bathrooms_override_from_unit_type, Float, default: lambda { |rs, attribute| self.bathrooms_override_from(rs.unit_type) }

    def self.new_from(args)
      args[:bedrooms] = args.delete(:bed_rooms) unless args[:bedrooms]
      args[:bathrooms] = args.delete(:bath_rooms) unless args[:bathrooms]
      args[:avg_square_feet] = args.delete(:avg_sq_ft) unless args[:avg_square_feet]

      self.new(args)
    end

    private

    def self.bedrooms_override_from(unit_type)
      bed_and_bath_unit_type_split(unit_type)[0].to_f
    end

    def self.bathrooms_override_from(unit_type)
      bed_and_bath_unit_type_split(unit_type)[1].to_f
    end

    def self.bed_and_bath_unit_type_split(unit_type)
      unit_type.split('x')
    end
  end

end
