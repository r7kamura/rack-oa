module Rack
  module Oa
    module Actions
      class Base
        # @param env [Hash] Rack env
        # @param authorization_class [Class] A class that provides storage logic for authorization
        def initialize(env: nil, authorization_class: nil)
          @env = env
          @authorization_class = authorization_class
        end

        # @param env [Hash] Rack env
        # @return [Array] Rack response
        def call
          response.to_rack_response
        end

        private

        # @return [Rack::Request]
        def request
          @request ||= Rack::Request.new(@env)
        end
      end
    end
  end
end
