module Rack
  module Oa
    module Responses
      class InvalidRequest < Base
        private

        def params
          {
            error: "invalid_request",
            error_message: "Access token was not given"
          }
        end

        def status
          401
        end
      end
    end
  end
end
