module Realms
  module Actions
    class AcquireCard < Action
      attr_reader :player, :card, :turn
      attr_accessor :zone

      def initialize(player, card)
        @player = player
        @card = card
        @turn = player.active_turn
        @zone = :discard_pile
      end

      def execute
        turn.trade -= card.cost
        turn.event_manager.changed
        turn.event_manager.notify_observers(self)

        # TODO: consider pulling this out into a zone transfer?
        turn.trade_deck.acquire(card)
        turn.active_player.deck.acquire(card, zone: zone)
      end
    end
  end
end
