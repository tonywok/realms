module Realms
  module Actions
    class AcquireCard < Action
      def self.key
        :acquire
      end

      def execute
        turn.trade -= card.cost
        active_player.acquire(card)
      end
    end
  end
end
