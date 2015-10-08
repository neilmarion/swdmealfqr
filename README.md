# YieldStar Client #

Client adapter for the YieldStar AppExchange web service.

## Installation ##

The YieldStar adapter is available on [Rubygems][rubygems] and can be installed via:

        gem install 'yield_star_client'

## Configuration ##

You will probably only need to configure the username and password for connecting to the remote service:

        YieldStarClient.configure do |config|
            config.username = 'my_user'
            config.password = 'my_pass'
        end

Sensible defaults are provided for other configuration options. **TODO**: link to the docs for the rest of the config.

## Factories

To make testing in your apps easier, `require 'yield_star_client/factories'` to import FactoryGirl factories. See that file for available factories.

## Examples ##

**TODO:** More thorough usage examples.

```ruby
client = YieldStarClient::Client.new(
  username: "abc",
  password: "efg",
)
# See YieldStarClient::VALID_CONFIG_OPTIONS for all available options
client.get_properties('my_client_name')
```

**TODO:** Link to docs for more info.

## More Information ##

* [YieldStar documentation][yieldstar-docs]
* [YieldStar WSDL][yieldstar-wsdl]

 [rubygems]: http://rubygems.org/gems/yield_star_client
 [yieldstar-docs]: http://rmsws.yieldstar.com/rmsws/doc/AppExchange/index.html
 [yieldstar-wsdl]: http://rmsws.yieldstar.com/rmsws/AppExchange?wsdl
