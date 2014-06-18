module Rack
  module Oa
    module Responses
      class ValidAccessToken < Base

        # @param authorization [Rack::Oa::Authorization] An object that behaves like an authorization record
        def initialize(authorization: nil)
          @authorization = authorization
        end

        private

        def params
          @authorization.to_hash
        end

        def status
          200
        end
      end
    end
  end
end
