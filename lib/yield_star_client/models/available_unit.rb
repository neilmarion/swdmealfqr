module YieldStarClient

  # Represents an available unit.
  #
  # @attr [String] building the building for this unit
  # @attr [String] unit_type the unit type
  # @attr [String] unit_number the unit number from the property management system
  # @attr [Array<String>] features the list of unit amenities/features
  # @attr [Symbol] status the availability status of this unit. The status may be one of the
  #                       following values:
  #                       * +:on_notice+
  #                       * +:vacant+
  #                       * +:new_unit+
  #                       * +:unknown+
  # @attr [Date] date_available the date this unit can be occupied
  # @attr [Integer] base_market_rent the 12-month market rent
  # @attr [Integer] base_concession the concession amountt
  # @attr [Integer] base_final_rent the 12-month effective rent (market rent less concessions)
  # @attr [Integer] best_lease_term the lease term associated with the best price from
  #                                 the Lease Term Rent Matrix.
  # @attr [Integer] best_market_rent the market monthly rent associated with the best price
  #                                  term and move-in period
  # @attr [Integer] best_concession the concession associated with the best price term
  #                                 and move-in period
  # @attr [Integer] best_final_rent the effective monthly rent associated with the best
  #                                 price term and move-in period
  class AvailableUnit < Modelish::Base
    property :building
    property :unit_type
    property :unit_number
    property :features, :type => Array, :default => [], :from => :feature
    property :status, :type => Symbol
    property :date_available, :type => Date
    property :base_market_rent, :type => Integer
    property :base_concession, :type => Integer
    property :base_final_rent, :type => Integer
    property :best_lease_term, :type => Integer
    property :best_market_rent, :type => Integer
    property :best_concession, :type => Integer
    property :best_final_rent, :type => Integer

    def id
      concat = [building, unit_type, unit_number].join("-")
      Digest::SHA1.hexdigest concat
    end
  end

end
