# Rack::Oa
Rack middleware for OAuth 2.0

## Usage
This library provides `Rack::Oa::Middleware` to help developers implement OAuth 2.0 Provider.

```ruby
use(
  Rack::Oa::Middleware,
  authorization_class: Authorization,
  client_class: Client,
  resource_owner_class: ResourceOwner,
)
```

### Required options
As you can see in the above example,
you need to pass 3 classes to persist and search records.
Each classes (you can also pass non-class object while it's recommended to use class object),
must respond to the following methods and the returned-values also must respond to `.to_hash` method.

* authorization_class
 * .create
 * .find_by
* client_class
 * .find_by
* resource_owner_class
 * .find_by
