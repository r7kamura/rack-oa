module Rack
  module Oa
    module Responses
      class InvalidClient < Base
        private

        def params
          {
            error: "invalid_client",
            error_message: "Client or resource owner was not found"
          }
        end

        def status
          401
        end
      end
    end
  end
end
