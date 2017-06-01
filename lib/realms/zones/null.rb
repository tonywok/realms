module Realms
  module Zones
    class Null < Zone
      def cards
        []
      end

      def include?(card)
        true
      end

      def index(card)
      end

      def remove(card)
        card
      end
    end
  end
end
