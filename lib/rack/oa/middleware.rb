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
        @app.call(env)
      end
    end
  end
end
