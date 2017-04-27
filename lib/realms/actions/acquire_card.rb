module Realms
  module Actions
    class AcquireCard < Action
      include Wisper::Publisher

      attr_accessor :zone

      def self.key
        :acquire
      end

      def execute
        turn.trade -= card.cost
        active_player.deck.acquire(card)
      end
    end
  end
end
