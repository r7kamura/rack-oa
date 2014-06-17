module Rack
  module Oa
    module Actions
      class AccessTokenValidation
        # Wrapper of #call
        def self.call(env)
          new(env).call
        end

        # @param env [Hash] Rack env
        def initialize(env)
          @env = env
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
          when access_token
            Responses::ValidAccessToken.new
          else
            Responses::InvalidRequest.new
          end
        end

        # @return [String, nil] Access token given from user-agent
        def access_token
          access_token_from_header || access_token_from_parameter
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
