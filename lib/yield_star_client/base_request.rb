module YieldStarClient
  class BaseRequest

    include Virtus.model
    include ActiveModel::Validations

    attribute :client_name, String
    attribute :endpoint, String
    attribute :namespace, String
    attribute :username, String
    attribute :password, String
    attribute :logger
    attribute :log, Boolean

    validates(
      :client_name,
      :endpoint,
      :namespace,
      :username,
      :password,
      presence: true,
    )
    validates :client_name, length: {maximum: 50}

    def self.execute(attributes)
      self.new(attributes).execute
    end

    def execute
      fail ArgumentError, errors.full_messages.join("; ") if invalid?
      soap_action = self.class.const_get("SOAP_ACTION")
      fail ArgumentError, "define SOAP_ACTION" unless soap_action

      SoapClient.request(soap_action, attributes)
    end

  end
end
