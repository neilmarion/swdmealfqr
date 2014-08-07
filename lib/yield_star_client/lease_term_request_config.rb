module YieldStarClient
  module LeaseTermRequestConfig
    def configure_for_lease_term_rent(opts={})
      include Methods
      self.lease_term_request_opts = opts
    end

    module Methods
      extend ActiveSupport::Concern

      included do
        class_attribute :lease_term_request_opts

        attribute :external_property_id, String
        attribute :unit_number, String

        validates :external_property_id, :unit_number, presence: true
      end

      def request_args
        lease_term_rent_options = LeaseTermRentOptions.
          new(attributes.slice(:unit_number))
        request_element = self.class.lease_term_request_opts.
          fetch(:request_element)
        attributes.merge(
           request_element => lease_term_rent_options.to_request_hash
        )
      end
    end
  end

  BaseRequest.extend LeaseTermRequestConfig
end
