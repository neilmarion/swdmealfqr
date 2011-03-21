require 'modelish'

module YieldStarClient
  # @private
  module Validations
    include Modelish::Validations::ClassMethods

    def validate_client_name!(client_name)
      validate_required!(:client_name => client_name)
      validate_length!(:client_name, client_name, 16)
    end

    def validate_external_property_id!(external_property_id)
      validate_required!(:external_property_id => external_property_id)
      validate_length!(:external_property_id, external_property_id, 50)
    end
  end
end
