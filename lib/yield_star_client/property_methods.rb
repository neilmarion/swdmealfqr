module YieldStarClient
  module PropertyMethods

    def get_properties
      response = GetProperties::Request.execute(default_savon_params)
      GetProperties::Response.new(response).properties
    end

    def get_property(external_property_id)
      response = GetProperty::Request.execute(
        default_savon_params.merge(external_property_id: external_property_id)
      )
      GetProperty::Response.new(response).property
    end

    def get_property_parameters(external_property_id)
      response = GetPropertyParameters::Request.execute(
        default_savon_params.merge(external_property_id: external_property_id)
      )
      GetPropertyParameters::Response.new(response).property_parameters
    end

  end
end
