module YieldStarClient
  module LeaseTermResponseConfig
    def configure_for_lease_term_rent(opts)
      class_attribute :lease_term_response_opts
      self.lease_term_response_opts = opts
      include Methods
    end

    module Methods
      extend ActiveSupport::Concern

      included do
        accessor_method = lease_term_response_opts.fetch(:accessor_method)

        define_method accessor_method do
          return @models if @models
          result_class = self.class.lease_term_response_opts.
            fetch(:result_class)
          hashes = extract_lease_term_rent_hashes(@soap_response)
          @models = hashes.map do |hash|
            result_class.new_from(hash)
          end
        end
      end

      private

      def extract_lease_term_rent_hashes(soap_response)
        opts = self.class.lease_term_response_opts
        soap_hash_accessors = {
          soap_wrapper_element: opts.fetch(:soap_wrapper_element),
          soap_unit_element: opts.fetch(:soap_unit_element),
        }

        ExtractLeaseTermRentHashes.from(soap_response, soap_hash_accessors)
      end

    end
  end

  BaseResponse.extend LeaseTermResponseConfig
end
