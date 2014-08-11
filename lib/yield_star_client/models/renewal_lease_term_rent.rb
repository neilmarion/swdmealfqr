module YieldStarClient
  # Represents rate data for a unit that is up for lease renewal.
  #
  # @attr {see YieldStarClient::UnitRate}
  # @attr [Date] start_date the actual start date of the projected lease (this will only be
  #                         present when a start date was passed in as input
  class RenewalLeaseTermRent < UnitRate

    attribute :start_date, Date

  end
end
