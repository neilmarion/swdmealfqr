module YieldStarClient
  class Amenity < Modelish::Base

    property :name
    property :type
    property :value, :type => Float

  end
end
