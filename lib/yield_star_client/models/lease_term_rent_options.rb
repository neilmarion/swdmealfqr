module YieldStarClient
  class LeaseTermRentOptions

    include Virtus.model
    include ActiveModel::Validations

    attribute :unit_number, String
    attribute :building, String
    attribute :min_lease_term, Integer
    attribute :max_lease_term, Integer
    attribute :first_move_in_date, Date
    attribute :last_move_in_date, Date
    attribute :ready_for_move_in_date, Date
    attribute :unit_available_date, Date
    attribute :start_date, Date

    validates :unit_number, presence: true
    validates :building, length: { maximum: 50 }

    def to_request_hash
      self.attributes.select do |name, value|
        !value.nil?
      end
    end

    def validate!
      fail ArgumentError if invalid?
    end

  end
end
