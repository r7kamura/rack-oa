# Rack::Oa
Rack middleware for OAuth 2.0

## Usage
This library provides `Rack::Oa::Middleware` to help developers implement OAuth 2.0 Provider.

### GET /oauth/token
Rack::Oa::Middleware provides `GET /oauth/token` as a token validator API.
To have this work well, you need to pass authorization class object
that responds to `.find_by` method via :authorization_class option.
This class method must return an object that responds to `.to_hash` method,
which will be used as a response body to be returned to user-agent.

```ruby
# Suppose that you have OauthAccessToken ActiveRecord class to persist access tokens.
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

use Rack::Oa::Middleware, authorization_class: Authorization
```
