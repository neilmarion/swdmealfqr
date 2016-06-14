module YieldStarClient
  class ExtractLeaseTermRentHashes

    def self.from(soap_response, soap_hash_accessors)
      soap_wrapper_element = soap_hash_accessors.
        fetch(:soap_wrapper_element)
      soap_unit_element = soap_hash_accessors.fetch(:soap_unit_element)

      return_element = soap_response.
        to_hash[soap_wrapper_element][:return]

      external_property_id = return_element[:external_property_id]

      ltr_unit_response_hashes = return_element[soap_unit_element] || {}
      ltr_unit_response_hashes = [ltr_unit_response_hashes].flatten

      ltr_unit_response_hashes.inject([]) do |lease_term_rent_hashes, ltr_unit_response_hash|
        lease_term_rent_hashes + convert_response_hash_into_ltr_hashes(ltr_unit_response_hash, external_property_id)
      end
    end

    def self.convert_response_hash_into_ltr_hashes(ltr_unit_response_hash, external_property_id)
      unit_rates = [ltr_unit_response_hash[:unit_rate]].flatten.compact
      unit_rates.map do |unit_rate|
        hash = unit_rate.
          merge(ltr_unit_response_hash.reject { |k, v| k == :unit_rate }).
          merge(external_property_id: external_property_id)
      end
    end

  end
end
