module Rack
  module Oa
    module Actions
      class AccessTokenFactory < Base
        private

        def response
          case
          when !has_client_id?, !has_client_secret?
            Responses::InvalidRequest.new
          else
            Responses::NewAccessToken.new
          end
        end

        def has_client_id?
          request.params.has_key?("client_id")
        end

        def has_client_secret?
          request.params.has_key?("client_secret")
        end
      end
    end
  end
end
