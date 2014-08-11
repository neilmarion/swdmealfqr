module YieldStarClient

  # Represents a unit in the YieldStar system.
  #
  # A unit is guaranteed to have an +external_property_id+, +floor_plan_name+, +name+, and +availablity_status+.
  # All other attributes are optional.
  #
  # @attr [String] external_property_id the property ID
  # @attr [String] floor_plan_name the name of the unit's floor plan
  # @attr [String] name the unit name
  # @attr [Symbol] availability_status the current availability of the unit. This may be one of the following values:
  #   * +:occupied+ -- this unit is presently leased by a resident
  #   * +:occupied_on_notice+ -- this unit is presently leased by a resident but a notice date has been provided
  #   * +:vacant+ -- this unit is not presently leased
  #   * +:pending+ -- this unit is available but a lease is pending
  #   * +:unknown+ -- the status is unknown or unrecognized
  # @attr [String] building the name of the building associated with the unit
  # @attr [Float] bedrooms the number of bedrooms in the unit
  # @attr [Float] bathrooms the number of bathrooms in the unit
  # @attr [Integer] square_feet the square footage of the unit
  # @attr [String] unit_type the client-defined grouping of the unit
  # @attr [Date] make_ready_date the date on which the unit is ready for move-in
  class Unit < Modelish::Base
    property :external_property_id
    property :floor_plan_name
    property :name
    property :availability_status, :type => Symbol
    property :building
    property :bedrooms, :from => :bed_rooms, :type => Float
    property :bathrooms, :from => :bath_rooms, :type => Float
    property :square_feet, :type => Integer, :from => :square_footage
    property :unit_type
    property :make_ready_date, :type => Date
  end

end
