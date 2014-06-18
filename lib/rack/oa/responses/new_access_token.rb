module Rack
  module Oa
    module Responses
      class NewAccessToken < Base
        def initialize(authorization_class: nil, client: nil, resource_owner: nil, scopes: nil)
          @authorization_class = authorization_class
          @client = client
          @resource_owner = resource_owner
          @scopes = scopes
        end

        private

        def params
          @authorization_class.create(
            client: @client,
            resource_owner: @resource_owner,
            scopes: @scopes,
          ).to_hash
        end

        def status
          201
        end
      end
    end
  end
end
