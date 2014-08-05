module YieldStarClient
  # Represents the pricing parameters for a particular property.
  #
  # This object is guaranteed to have an +external_property_id+; all other attributes may be nil.
  #
  # @attr [String] external_property_id the ID of the property
  # @attr [Date] post_date the post date of the latest Price Optimizer forecasting and optimization nightly run.
  # @attr [Integer] min_new_lease_term minimum length (in months) of a new lease term
  # @attr [Integer] max_new_lease_term maximum length (in months) of a new lease term
  # @attr [Integer] new_lease_term_options absolute number of lease term options to offer on either side of the base lease term when creating the lease term rent matrix.
  # @attr [Integer] max_move_in_days number of fixed move in date options to return in response to a request for lease rates.
  # @attr [Integer] min_renewal_lease_term minimum length (in months) of a renewal lease term
  # @attr [Integer] max_renewal_lease_term maximum length (in months) of a renewal lease term
  class PropertyParameters

    include Virtus.model

    attribute :external_property_id, String
    attribute :post_date, Date
    attribute :min_new_lease_term, Integer
    attribute :max_new_lease_term, Integer
    attribute :new_lease_term_options, Integer
    attribute :max_move_in_days, Integer
    attribute :min_renewal_lease_term, Integer
    attribute :max_renewal_lease_term, Integer
  end
end
