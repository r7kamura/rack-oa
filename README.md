# Rack::Oa
Rack middleware for OAuth 2.0

## Usage
This library provides `Rack::Oa::Middleware` to help developers implement OAuth 2.0 Provider.

### Required classes
* authorization class
 * .create
 * .find_by
* client class
 * .find_by
* resource owner class
 * .find_by

### Example
```ruby
class Authorization
  # @param access_token [String] Access token string (e.g. "0b1a56c2452de3167a45")
  # @return [Object, nil] An object that responds to .to_hash method, or nil
  def self.find_by(access_token: nil)
    if token = OauthAccessToken.find_by(token: access_token)
      new(oauth_access_token)
    end
  end

  def initialize(oauth_access_token)
    @oauth_access_token = oauth_access_token
  end

  # @return [Hash] A hash to be encoded into JSON response body
  def to_hash
    {
      application: oauth_access_token.application.to_hash,
      created_at: oauth_access_token.created_at,
      note: oauth_access_token.note,
      scopes: oauth_access_token.scopes,
      token: oauth_access_token.token,
      updated_at: oauth_access_token.updated_at,
    }
  end
end

class Client
  def self.find_by(client_id: nil, client_secret: nil)
    if client = OauthClient.find_by(client_id: client_id, client_secret: client_secret)
      new(client)
    end
  end

  def initialize(client)
    @client = client
  end
end

class ResourceOwner
  def self.find_by(username: nil, password: nil)
    if user = User.find_by(username: username, password: password)
      new(user)
    end
  end

  def initialize(user)
    @user = user
  end
end

use(
  Rack::Oa::Middleware,
  authorization_class: Authorization,
  client_class: Client,
  resource_owner_class: ResourceOwner,
)
```
