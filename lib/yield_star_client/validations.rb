module YieldStarClient
  # @private
  module Validations
    def validate_client_name(client_name)
      validate_required(:client_name, client_name)
      validate_length(:client_name, client_name, 16)
    end

    def validate_external_property_id(external_property_id)
      validate_required(:external_property_id, external_property_id)
      validate_length(:external_property_id, external_property_id, 50)
    end

    def validate_required(name, value)
      raise ArgumentError.new("#{name} must not be nil or blank") if value.nil? || value.to_s.strip.empty? 
    end

    def validate_length(name, value, length)
      raise ArgumentError.new("#{name} must be less than #{length} characters") if value && length && value.to_s.length > length
    end
  end
end
