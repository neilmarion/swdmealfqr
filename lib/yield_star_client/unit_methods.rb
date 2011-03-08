require 'validations'
require 'errors'

module YieldStarClient
  module UnitMethods
    include Validations
    # Retrieves data about a specific unit.
    #
    # A unit is guaranteed to have the following attributes:
    #
    # <b>+:external_property_id+</b>:: the property ID +(String)+
    # <b>+:floor_plan_name+</b>:: the name of the unit's floor plan +(String)+
    # <b>+:name+</b>:: the unit name +(String)+
    # <b>+:availability_status+</b>:: The current availability of the unit. This may be one of the following values:
    # * +:occupied+ -- this unit is presently leased by a resident
    # * +:occupied_on_notice+ -- this unit is presently leased by a resident but a notice date has been provided
    # * +:vacant+ -- this unit is not presently leased
    # * +:pending+ -- this unit is available but a lease is pending
    # * +:unknown+ -- the status is unknown or unrecognized
    #
    # Additionally, the unit may have any of the following optional attributes:
    #
    # <b>+:building+</b>:: the name of the building associated with the unit +(String)+
    # <b>+:bed_rooms+</b>:: the number of bedrooms in the unit +(Float)+
    # <b>+:bath_rooms+</b>:: the number of bathrooms in the unit +(Float)+
    # <b>+:square_footage+</b>:: the square footage of the unit +(Integer)+
    # <b>+:unit_type+</b>:: the client-defined grouping of the unit +(String)+
    # <b>+:make_ready_date+</b>:: the date on which the unit is ready for move-in +(Date)+
    #
    # @param [String] client_name the YieldStar client name
    # @param [String] external_property_id the ID of the property where the unit is located
    # @param [String] unit_name the name of the unit to retrieve
    # @param [optional,String] building_name the name of the building in which the unit is located
    #
    # @return [Hash] the unit data
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_unit(client_name, external_property_id, unit_name, building_name=nil)
      validate_client_name(client_name)
      validate_external_property_id(external_property_id)
      validate_required(:unit_name => unit_name)

      body = {:client_name => client_name, :external_property_id => external_property_id, :name => unit_name}
      body[:building] = building_name if building_name

      response = send_soap_request(:get_unit, body)
      unit = response.to_hash[:get_unit_response][:return][:unit]
      
      process_unit(unit)
    end

    # Retrieves all units for a specific property, optionally filtered by floor plan.
    #
    # @see #get_unit
    # 
    # @param [String] client_name the YieldStar client name
    # @param [String] external_property_id the ID of the property where the units are located
    # @param [String] floor_plan_name (optional) the name of the floor plan associated with the units
    # 
    # @return [Array<Hash>] a list of unit data
    #
    # @raise [ArgumentError] when a required argument is missing or invalid
    # @raise [YieldStarClient::AuthenticationError] when unable to authenticate to the web service
    # @raise [YieldStarClient::OperationError] when the service raises an OperationError fault
    # @raise [YieldStarClient::InternalError] when the service raises an InternalError fault
    # @raise [YieldStarClient::ServerError] when any other server-side error occurs
    def get_units(client_name, external_property_id, floor_plan_name=nil)
      validate_client_name(client_name)
      validate_external_property_id(external_property_id)
      
      body = {:client_name => client_name, :external_property_id => external_property_id}
      body[:floor_plan_name] = floor_plan_name if floor_plan_name
      response = send_soap_request(:get_units, body)

      units = response.to_hash[:get_units_response][:return][:unit] || []
      units = [units].flatten
      
      units.collect { |u| process_unit(u) }
    end

    private
    def process_unit(unit)
      unit[:availability_status] = unit[:availability_status].to_s.downcase.gsub(/\s+/,'_').to_sym
      [:bed_rooms, :bath_rooms].each { |k| unit[k] = unit[k].to_f if unit.has_key?(k) }
      unit[:square_footage] = unit[:square_footage].to_i if unit.has_key?(:square_footage)
      unit[:make_ready_date] = Date.parse(unit[:make_ready_date]) if unit.has_key?(:make_ready_date)
      unit
    end
  end
end
