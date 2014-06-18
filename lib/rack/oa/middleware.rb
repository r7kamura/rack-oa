module Rack
  module Oa
    class Middleware
      # @param app [Object] Rack application
      # @param authorization_class [Class] A class that provides storage logic for authorization
      def initialize(app, authorization_class: nil, client_class: nil, resource_owner_class: nil)
        @app = app
        @authorization_class = authorization_class
        @client_class = client_class
        @resource_owner_class = resource_owner_class
      end

      # @param env [Hash] Rack env
      # @return [Array] Rack response
      def call(env)
        multiplexer.call(env)
      end

      private

      # @return [Rack::Multiplexer] Router as a Rack application
      def multiplexer
        @multiplexer ||= Rack::Multiplexer.new(@app).tap do |router|
          router.get "/oauth/token" do |env|
            Actions::AccessTokenValidation.new(
              env: env,
              authorization_class: @authorization_class,
            ).call
          end

          router.post "/oauth/token" do |env|
            Actions::AccessTokenFactory.new(
              env: env,
              authorization_class: @authorization_class,
              client_class: @client_class,
              resource_owner_class: @resource_owner_class,
            ).call
          end
        end
      end
    end
  end
end
