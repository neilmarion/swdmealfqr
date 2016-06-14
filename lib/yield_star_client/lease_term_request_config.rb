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
        attribute :units
        attribute :unit_number, String
        attribute :building, String
        attribute :min_lease_term, String
        attribute :max_lease_term, String
        attribute :first_move_in_date, Date
        attribute :last_move_in_date, Date

        validates :external_property_id, presence: true
      end

      def request_args
        if units
          lease_term_rent_options = [units].flatten.map do |options_hash|
            options_hash.slice(
              :unit_number,
              :building,
              :min_lease_term,
              :max_lease_term,
              :first_move_in_date,
              :last_move_in_date,
            )
          end
        else
          lease_term_rent_options = LeaseTermRentOptions.new(attributes.slice(
            :unit_number,
            :building,
            :min_lease_term,
            :max_lease_term,
            :first_move_in_date,
            :last_move_in_date,
          )).to_request_hash
        end
        request_element = self.class.lease_term_request_opts.
          fetch(:request_element)
        attributes.merge(
           request_element => lease_term_rent_options
        )
      end
    end
  end

  BaseRequest.extend LeaseTermRequestConfig
end
