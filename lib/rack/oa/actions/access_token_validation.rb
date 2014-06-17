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
          [401, {}, [""]]
        end

        private

        # @return [String, nil] Access token given from user-agent
        def access_token
          access_token_from_header || access_token_from_parameter
        end

        # @return [String, nil] Access token extracted from Authorization header
        def access_token_from_header
        end

        def request_header
        end

        def request
          @request ||= Rack::Request.new(@env)
        end
      end
    end
  end
end
