module YieldStarClient

  # Represents a floor plan with available units.
  #
  # @attr [String] external_property_id the ID of the property associated with the
  #                                     floor plan
  # @attr [Date] effective_date the date that all listed prices are considered effective
  # @attr [String] floor_plan_name the name of the floor plan that matches the 
  #                                Price Optimizer dashboard
  # @attr [Array<AvailableUnit>] units the available unit data associated with this
  #                                    floor plan
  # @attr [Float] bedrooms the number of bedrooms in this floor plan
  # @attr [Float] bathrooms the number of bathrooms in this floor plan
  # @attr [Integer] square_feet the square footage of the floor plan
  class AvailableFloorPlan < Modelish::Base
    property :external_property_id
    property :effective_date, :type => Date
    property :floor_plan_name
    property :bedrooms, :type => Float, :from => :bed_rooms
    property :bathrooms, :type => Float, :from => :bath_rooms
    property :square_feet, :type => Integer, :from => :sq_ft
    property :units, :from => :unit, :default => []

    def initialize(options = {})
      super(options)

      # TODO: add support for nested types to modelish?
      self.units = [self.units].flatten.collect { |u| AvailableUnit.new(u) }
    end
  end

end
