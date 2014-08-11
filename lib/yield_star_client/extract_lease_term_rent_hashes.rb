module YieldStarClient
  class ExtractLeaseTermRentHashes

    def self.from(soap_response, soap_hash_accessors)
      soap_wrapper_element = soap_hash_accessors.
        fetch(:soap_wrapper_element)
      soap_unit_element = soap_hash_accessors.fetch(:soap_unit_element)

      return_element = soap_response.
        to_hash[soap_wrapper_element][:return]

      external_property_id = return_element[:external_property_id]
      lease_term_rent = return_element[soap_unit_element] || {}

      unit_rates = [lease_term_rent[:unit_rate]].flatten.compact
      unit_rates.map do |unit_rate|
        hash = unit_rate.
          merge(lease_term_rent.reject { |k, v| k == :unit_rate }).
          merge(external_property_id: external_property_id)
      end
    end

  end
end
