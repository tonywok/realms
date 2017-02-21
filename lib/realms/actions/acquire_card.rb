module Realms
  module Actions
    class AcquireCard < Action
      attr_reader :player, :card

      def initialize(player, card)
        @player = player
        @card = card
      end

      def execute
        player.deck.acquire(card)
        card.player.active_turn.trade -= card.cost
      end
    end
  end
end
