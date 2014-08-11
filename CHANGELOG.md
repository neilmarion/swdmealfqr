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
