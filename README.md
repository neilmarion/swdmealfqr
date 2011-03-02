# YieldStar Client #

Client adapter for the YieldStar AppExchange web service.

## Installation ##

1. Add this to your Gemfile:

        gem 'yield_star_client', :git => 'git@github.com:g5search/yield_star_client.git'

2. Execute `bundle install`

## Configuration ##

You will probably only need to configure the username and password for connecting to the remote service:

        YieldStarClient.configure do |config|
            config.username = 'my_user'
            config.password = 'my_pass'
        end

Sensible defaults are provided for other configuration options. **TODO**: link to the docs for the rest of the config.

## Examples ##

**TODO:** More thorough usage examples.

        client = YieldStarClient::Client.new
        client.get_properties('my_client_name')

**TODO:** Link to docs for more info.

## More Information ##

* [YieldStar documentation][yieldstar-docs]
* [YieldStar WSDL][yieldstar-wsdl]

 [yieldstar-docs]: http://rmsws.yieldstar.com/rmsws/doc/AppExchange/index.html
 [yieldstar-wsdl]: http://rmsws.yieldstar.com/rmsws/AppExchange?wsdl
