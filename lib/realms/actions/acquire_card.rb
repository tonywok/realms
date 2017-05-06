module Realms
  module Actions
    class AcquireCard < Action
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
