## TBA

* Add initial set of factories

## 1.2.0

* Include `#bedrooms_override_from_unit_type` and `#bathrooms_override_from_unit_type` in RentSummary#to_hash

## 1.1.0

* Add `#bedrooms_override_from_unit_type` and `#bathrooms_override_from_unit_type` to RentSummary.  These are calculated from the #unit_type as illustrated by the following:

```
rent_summary = RentSummary.new(unit_type: '3.5x2')
rent_summary.bedrooms_override_from_unit_type
=> 3.5
rent_summary.bathrooms_override_from_unit_type
=> 2
```
* Fix bug when fetching lease terms - Invalid building/unit XXXXXX

## 1.0.0.beta.1

* Change .rvmrc to .ruby-version. Use Ruby 1.9.3-p484.
* Refactor code to depend on Savon less, and upgrade to Savon 2.0

## 0.2.0 (2012-01-16)

* Moved the client_name to the configuration, since it is required
for every call to the remote service. The client_name parameter has
been removed from the method signature for all service calls, which
breaks backwards compatibility with v0.1.x.
* Added the :debug and :logger configuration options to prevent savon
from dumping all soap messages to STDOUT.
* Various minor cleanup around configuration.

## 0.1.1 (2011-06-14)

* Bug fix: explicitly namespace all require statements to avoid
collisions with other gems.

## 0.1.0 (2011-06-14)

* Initial release to rubygems.
