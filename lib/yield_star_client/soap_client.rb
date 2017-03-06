module YieldStarClient
  class SoapClient

    SAVON_CLIENT_PARAMS = [
      :endpoint,
      :namespace,
      :log,
      :logger,
      :username,
      :password,
    ]

    def self.request(action, params)
      request_params = params
      savon_client_params = savon_client_params_from(params)

      savon_client = ::Savon.client(savon_client_params)
      savon_client.call(
        action,
        message: {
          request: request_params,
        }
      )

    rescue Savon::SOAPFault, Savon::HTTPError => e
      raise ServerError.translate_fault(e)
    end

    private

    def self.savon_client_params_from(params)
      savon_client_params = SAVON_CLIENT_PARAMS.inject({}) do |hash, key|
        hash[key] = params.delete(key)
        hash
      end

      savon_client_params[:basic_auth] = [
        savon_client_params.delete(:username),
        savon_client_params.delete(:password)
      ]
      savon_client_params[:element_form_default] = :qualified
      savon_client_params
    end

  end
end
