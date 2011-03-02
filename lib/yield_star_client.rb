$:.unshift(File.expand_path('yield_star_client',File.dirname(__FILE__)))

module YieldStarClient
  autoload :Configlet, 'configlet'
  extend Configlet

  autoload :Client, 'client'

  # All valid configuration options.
  #
  # @see YieldStarClient.configure
  VALID_CONFIG_OPTIONS = [:endpoint, :username, :password, :namespace]

  DEFAULT_ENDPOINT = 'https://rmsws.yieldstar.com/rmsws/AppExchange'
  DEFAULT_NAMESPACE = 'http://yieldstar.com/ws/AppExchange/v1'

  # Default configuration - happens whether or not .configure is called
  config :yield_star do
    default :endpoint => DEFAULT_ENDPOINT
    default :namespace => DEFAULT_NAMESPACE
  end

  # Mutators and accessors for configuration options
  class << self
    VALID_CONFIG_OPTIONS.each do |config_opt|
      define_method(config_opt) do
        YieldStarClient[config_opt]
      end

      define_method("#{config_opt}=".to_sym) do |val|
        YieldStarClient[config_opt] = val
      end
    end
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
  #   end
  # @example Overriding defaults
  #   YieldStarClient.configure do |config|
  #     config.username = 'my_user'
  #     config.password = 'my_pass'
  #     config.endpoint = 'http://my.endpoint.com'
  #     config.namespace = 'http://my.namespace.com'
  #   end
  # @return [YieldStarClient] _self
  # @see VALID_CONFIG_OPTIONS
  def self.configure
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
  def self.reset
    VALID_CONFIG_OPTIONS.each { |opt| self.send("#{opt}=", nil) } 
  end
end
