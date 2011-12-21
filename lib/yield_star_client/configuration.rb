require 'configlet'
require 'logger'

module YieldStarClient
  # All valid configuration options.
  #
  # @see YieldStarClient.configure
  VALID_CONFIG_OPTIONS = [:endpoint, :username, :password, :namespace, :client_name,
                          :debug, :logger]

  DEFAULT_ENDPOINT = 'https://rmsws.yieldstar.com/rmsws/AppExchange'
  DEFAULT_NAMESPACE = 'http://yieldstar.com/ws/AppExchange/v1'

  module Configuration
    include Configlet

    def self.extended(base)
      # Default configuration - happens whether or not .configure is called
      base.config :yield_star do
        default :endpoint => DEFAULT_ENDPOINT
        default :namespace => DEFAULT_NAMESPACE
        default :debug => false
      end
    end

    # Mutators and accessors for simple configuration options
    VALID_CONFIG_OPTIONS.each do |config_opt|
      define_method(config_opt) do
        self[config_opt]
      end

      define_method("#{config_opt}=".to_sym) do |val|
        self[config_opt] = val ? val.to_s : nil
      end
    end

    # True if debug logging of SOAP requests and responses has been enabled;
    # false otherwise.
    def debug?
      self[:debug] == 'true'
    end

    # Custom logger object for debug logging; defaults to STDOUT.
    attr_writer :logger

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    # Configures this module through the given +block+.
    # Default configuration options will be applied unless 
    # they are explicitly overridden in the +block+.
    #
    # @yield [_self] configures service connection options
    # @yieldparam [YieldstarClient] _self the object on which the configure method was called
    # @example Typical case utilizing defaults
    #   YieldStarClient.configure do |config|
    #     config.username = 'my_user'
    #     config.password = 'my_pass'
    #     config.client_name = 'my_client'
    #   end
    # @example Overriding defaults
    #   YieldStarClient.configure do |config|
    #     config.username = 'my_user'
    #     config.password = 'my_pass'
    #     config.client_name = 'my_client'
    #     config.endpoint = 'http://my.endpoint.com'
    #     config.namespace = 'http://my.namespace.com'
    #     config.debug = true
    #     config.logger = Logger.new('my.log')
    #   end
    # @return [YieldStarClient] _self
    # @see VALID_CONFIG_OPTIONS
    def configure
      config :yield_star do
        yield self
      end

      self
    end

    # Resets this module's configuration.
    # Configuration options will be set to default values
    # if they exist; otherwise, they will be set to nil.
    #
    # @see VALID_CONFIG_OPTIONS
    # @see DEFAULT_ENDPOINT
    # @see DEFAULT_NAMESPACE
    def reset
      VALID_CONFIG_OPTIONS.each { |opt| self.send("#{opt}=", nil) }
      self.logger = nil
    end
  end
end
