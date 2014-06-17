module Rack
  module Oa
    module Responses
      class ValidAccessToken < Base
        private

        def params
          {}
        end

        def status
          200
        end
      end
    end
  end
end
