module Rack
  module Oa
    module Responses
      class Base
        # @return [Array] Rack response
        # @note Override #params and #status
        def to_rack_response
          [status, headers, [body]]
        end

        private

        # @return [String]
        def body
          JSON.pretty_generate(params)
        end

        # @return [Hash]
        def headers
          { "Content-Type" => "application/json; charset=utf-8" }
        end
      end
    end
  end
end
