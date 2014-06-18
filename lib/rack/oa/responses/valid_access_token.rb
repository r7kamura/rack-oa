module Rack
  module Oa
    module Responses
      class ValidAccessToken < Base
        # Register a given value as its parameter name
        # @param parameter_name [Symbol]
        def self.parameter(parameter_name)
          parameter_names << parameter_name
        end

        # @return [Array]
        def self.parameter_names
          @parameter_names ||= []
        end

        parameter :application
        parameter :created_at
        parameter :note
        parameter :scopes
        parameter :token
        parameter :updated_at

        # @param authorization [Rack::Oa::Authorization] An object that behaves like an authorization record
        def initialize(authorization: nil)
          @authorization = authorization
        end

        private

        def params
          self.class.parameter_names.inject({}) do |result, parameter_name|
            result.merge(parameter_name => @authorization.send(parameter_name))
          end
        end

        def status
          200
        end
      end
    end
  end
end
