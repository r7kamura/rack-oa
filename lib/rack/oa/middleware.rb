module Rack
  module Oa
    class Middleware
      # @param app [Object] Rack application
      def initialize(app)
        @app = app
      end

      # @param env [Hash] Rack env
      # @return [Array] Rack response
      def call(env)
        multiplexer.call(env)
      end

      private

      # @return [Rack::Multiplexer] Router as a Rack application
      def multiplexer
        @multiplexer ||= Rack::Multiplexer.new(@app) do
          get "/oauth/token", Actions::AccessTokenValidation
        end
      end
    end
  end
end
