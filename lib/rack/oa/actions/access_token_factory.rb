module Rack
  module Oa
    module Actions
      class AccessTokenFactory < Base
        def initialize(client_class: nil, resource_owner_class: nil, **args)
          super(**args)
          @client_class = client_class
          @resource_owner_class = resource_owner_class
        end

        private

        def response
          case
          when !has_valid_scopes?
            Responses::InvalidScope.new
          when !has_client_id?, !has_client_secret?
            Responses::InvalidRequest.new
          when !has_client_or_resource_owner?
            Responses::InvalidClient.new
          when has_client?
            Responses::NewAccessToken.new(authorization_class: @authorization_class, client: client)
          else
            Responses::NewAccessToken.new(authorization_class: @authorization_class, resource_owner: resource_owner)
          end
        end

        def has_valid_scopes?
          (requested_scopes - valid_scopes).size == 0
        end

        def has_client_id?
          !!client_id
        end

        def has_client_secret?
          !!client_secret
        end

        def has_client?
          !!client
        end

        def has_resource_owner?
          !!resource_owner
        end

        def has_client_or_resource_owner?
          has_client? || has_resource_owner?
        end

        def client_id
          params["client_id"]
        end

        def client_secret
          params["client_secret"]
        end

        def requested_scopes
          params["scopes"]
        end

        def params
          @params ||= begin
            if %r<application/json> === request.content_type
              request.params.merge(params_from_json)
            else
              request.params
            end
          end
        end

        def params_from_json
          JSON.parse(body)
        end

        def body
          @body ||= request.body.read.tap { request.body.rewind }
        end

        def client
          @client ||= client_class.find_by(client_id: client_id, client_secret: client_secret)
        end

        def resource_owner
          @resource_owner ||= resource_owner_class.find_by(username: client_id, password: client_secret)
        end

        # TODO
        def client_class
          Class.new do
            def self.find_by(*args)
              new
            end
          end
        end

        # TODO
        def resource_owner_class
          Class.new do
            def self.find_by(*args)
              new
            end
          end
        end

        # TODO
        # @return [Array<String>]
        def valid_scopes
          []
        end
      end
    end
  end
end
