module YieldStarClient

  # Represents a floor plan in the YieldStar system.
  #
  # A floor plan is guaranteed to have an +external_property_id+ and +name+. All other attributes are
  # optional.
  #
  # @attr [String] external_property_id the property ID of this floor plan
  # @attr [String] name the name of this floor plan
  # @attr [String] description the description of this floor plan
  # @attr [Integer] square_feet the average square footage of this floor plan
  # @attr [Integer] unit_count the number of units with this floor plan
  # @attr [Float] bedrooms the bedroom count of the floor plan
  # @attr [Float] bathrooms the bathroom count of the floor plan
  class FloorPlan < Modelish::Base
    property :external_property_id
    property :name
    property :description
    property :square_feet, :type => Integer, :from => :square_footage
    property :unit_count, :type => Integer
    property :bedrooms, :type => Float, :from => :bed_rooms
    property :bathrooms, :type => Float, :from => :bath_rooms
  end

end
