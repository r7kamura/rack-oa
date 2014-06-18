module Rack
  module Oa
    class Authorization
      def self.find_by(access_token: nil)
        new
      end

      def to_hash
        {
          application: application,
          created_at: created_at,
          note: note,
          scopes: scopes,
          token: token,
          updated_at: updated_at,
        }
      end

      def application
      end

      def created_at
      end

      def note
      end

      def scopes
      end

      def token
      end

      def updated_at
      end
    end
  end
end
