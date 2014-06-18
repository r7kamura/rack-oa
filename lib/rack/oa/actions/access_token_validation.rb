module Rack
  module Oa
    module Actions
      class AccessTokenValidation
        # @param env [Hash] Rack env
        # @param authorization_class [Class] A class that provides storage logic for authorization
        def initialize(env: nil, authorization_class: nil)
          @env = env
          @authorization_class = authorization_class
        end

        # Validates access token, given from Authorization header or access_token parameter
        # @param env [Hash] Rack env
        # @return [Array] Rack response
        def call
          response.to_rack_response
        end

        private

        # @return [Rack::Oa::Responses::Base]
        def response
          case
          when authorization
            Responses::ValidAccessToken.new(authorization: authorization)
          else
            Responses::InvalidRequest.new
          end
        end

        # @return [Rack::Oa::Authorization, nil]
        def authorization
          if access_token
            @authorization_class.find_by(access_token: access_token)
          end
        end

        # @return [String, nil] Access token given from user-agent
        def access_token
          @access_token ||= access_token_from_header || access_token_from_parameter
        end

        # @return [String, nil]
        def access_token_from_header
          authorization_header && bearer_access_token
        end

        # @return [String, nil]
        def access_token_from_parameter
          request.params["access_token"]
        end

        # @return [Rack::Request]
        def request
          @request ||= Rack::Request.new(@env)
        end

        private

        # @return [String, nil]
        def authorization_header
          @authorization_header ||= @env["HTTP_AUTHORIZATION"]
        end

        # @return [String, nil]
        def bearer_access_token
          @bearer_access_token ||= authorization_header.to_s[/\ABearer (.+)/, 1]
        end
      end
    end
  end
end
