module YieldStarClient
  # Represents unit rate data for a combination of lease term
  # and move-in date for a particular unit.
  #
  # @attr {see YieldStarClient::UnitRate}
  # @attr [Date] make_ready_date the actual date the unit is made available
  # @attr [Date] move_in_date the move-in date used in project optimum rents for the unit
  # @attr [Integer] total_concession the total concession amount (defaults to 0)
  # @attr [Integer] monthly_fixed_concession the monthly fixed concession amount (defaults to 0)
  # @attr [Float] monthly_percent_concession the monthly concession percentage (defaults to 0.0)
  # @attr [Float] months_concession the months concession (defaults to 0.0)
  # @attr [Integer] one_time_fixed_concession the one time fixed concession (defaults to 0.0)
  # @attr [Date] price_valid_end_date the last date for which the price is valid
  class LeaseTermRent < UnitRate

    attribute :make_ready_date, Date
    attribute :move_in_date, Date
    attribute :total_concession, Integer, :default => 0
    attribute :monthly_fixed_concession, Integer, :default => 0
    attribute :monthly_percent_concession, Float, :default => 0.0
    attribute :months_concession, Float, :default => 0.0
    attribute :one_time_fixed_concession, Integer, :default => 0
    attribute :price_valid_end_date, Date

    def self.new_from(hash)
      hash[:price_valid_end_date] = hash.delete(:pv_end_date)
      self.new(hash)
    end

  end
end
