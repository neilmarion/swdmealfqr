# YieldStar Client #

Client adapter for the YieldStar AppExchange web service.

## Installation ##

The YieldStar adapter is available on [Rubygems][rubygems] and can be installed via:

```ruby
gem install 'yield_star_client'
```

## Configuration ##

You will probably only need to configure the username and password for connecting to the remote service:

```ruby
YieldStarClient.configure do |config|
  config.username = 'my_user'
  config.password = 'my_pass'
end
```

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

### getLeaseTermRent ###

```ruby
# give an externalPropertyId and a unitNumber
# suitable for quickly getting the lease terms of a single unit
client.get_lease_term_rent(
  "12345678", # externalPropertyId
  "A-328", # unitNumber
)

# complete set of parameters for a single unit
client.get_lease_term_rent(
  external_property_id: "12345678",
  units: {
    building: 2,
    unit_number: "A-328" # required
    min_lease_term: 0,
    max_lease_term: 100,
    first_move_in_date: "2016-05-01",
    last_move_in_date: "2016-05-01",
    ready_for_move_in_date: "2016-05-01",
    unit_available_date: "2016-05-01",
  }
)

# complete set of parameters for a multiple units
client.get_lease_term_rent(
  external_property_id: "12345678",
  units: [
    {
      building: 2,
      unit_number: "A-328" # required
      min_lease_term: 0,
      max_lease_term: 100,
      first_move_in_date: "2016-05-01",
      last_move_in_date: "2016-05-01",
      ready_for_move_in_date: "2016-05-01",
      unit_available_date: "2016-05-01",
    },
    {
      building: 2,
      unit_number: "A-329" # required
      min_lease_term: 0,
      max_lease_term: 100,
      first_move_in_date: "2016-05-01",
      last_move_in_date: "2016-05-01",
      ready_for_move_in_date: "2016-05-01",
      unit_available_date: "2016-05-01",
    }
  ]
)
```

**TODO:** Link to docs for more info.

## More Information ##

* [YieldStar documentation][yieldstar-docs]
* [YieldStar WSDL][yieldstar-wsdl]

 [rubygems]: http://rubygems.org/gems/yield_star_client
 [yieldstar-docs]: http://rmsws.yieldstar.com/rmsws/doc/AppExchange/index.html
 [yieldstar-wsdl]: http://rmsws.yieldstar.com/rmsws/AppExchange?wsdl
