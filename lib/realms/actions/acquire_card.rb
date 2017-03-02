module Realms
  module Actions
    class AcquireCard < Action
      attr_reader :player, :card

      def initialize(player, card)
        @player = player
        @card = card
      end

      def execute
        player.active_turn.trade -= card.cost
        player.active_turn.trade_deck.acquire(card)

        # TODO: Formalize this
        player.active_turn.event_manager.changed
        player.active_turn.event_manager.notify_observers(card)
        unless player.deck.include?(card)
          player.deck.acquire(card)
        end
      end
    end
  end
end
