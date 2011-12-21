require 'yield_star_client/validations'
require 'modelish'

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

  module UnitMethods
    include Validations
    # Retrieves data about a specific unit.
    #
    # @param [String] external_property_id the ID of the property where the unit is located
    # @param [String] unit_name the name of the unit to retrieve
    # @param [optional,String] building_name the name of the building in which the unit is located
    #
    # @return [YieldStarClient::Unit] the unit data
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_unit(external_property_id, unit_name, building_name=nil)
      validate_external_property_id!(external_property_id)
      validate_required!(:unit_name => unit_name)

      body = {:external_property_id => external_property_id, :name => unit_name}
      body[:building] = building_name if building_name

      response = send_soap_request(:get_unit, body)
      unit = response.to_hash[:get_unit_response][:return][:unit]

      Unit.new(unit)
    end

    # Retrieves all units for a specific property, optionally filtered by floor plan.
    #
    # @param [optional,String] floor_plan_name the name of the floor plan associated with the units
    # 
    # @return [Array<Unit>] a list of unit data
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_units(external_property_id, floor_plan_name=nil)
      validate_external_property_id!(external_property_id)

      body = {:external_property_id => external_property_id}
      body[:floor_plan_name] = floor_plan_name if floor_plan_name
      response = send_soap_request(:get_units, body)

      units = response.to_hash[:get_units_response][:return][:unit] || []
      units = [units].flatten

      units.collect { |u| Unit.new(u) }
    end
  end
end
