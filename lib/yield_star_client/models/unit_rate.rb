module YieldStarClient
  # Represents common unit rate information.
  #
  # @attr [String] external_property_id the ID of the property where the unit is located
  # @attr [String] building the building in which the unit is located
  # @attr [String] unit_number the unit number identifying this unit
  # @attr [Integer] lease_term the length, in months, of the lease term
  # @attr [Date] end_date the date the proposed lease will expire
  # @attr [Integer] market_rent the market rent for the current lease
  # @attr [Integer] final_rent the effective rent for the current lease
  # @attr [true,false] best indicates whether this is the best (i.e. highest) rent
  #                         for the unit; defaults to true
  class UnitRate

    include Virtus.model

    attribute :external_property_id, String
    attribute :building, String
    attribute :unit_number, String
    attribute :lease_term, Integer
    attribute :end_date, Date
    attribute :market_rent, Integer
    attribute :final_rent, Integer
    attribute :best, Boolean, default: true

    def self.new_from(*args)
      self.new(*args)
    end

  end
end
