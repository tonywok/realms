module Realms
  module Actions
    class AcquireCard < Action
      attr_reader :player, :card, :turn
      attr_accessor :zone

      def self.key
        :acquire
      end

      def initialize(turn)
        super
        @zone = :discard_pile
      end

      def execute
        choose Choice.new(purchasable_cards) do |card|
          turn.trade -= card.cost
          turn.event_manager.changed
          turn.event_manager.notify_observers(self)
          # TODO: consider pulling this out into a zone transfer?
          turn.trade_deck.acquire(card)
          turn.active_player.deck.acquire(card, zone: zone)
        end
      end

      def purchasable_cards
        cards = turn.trade_deck.trade_row + [turn.trade_deck.explorers.first]
        cards.select { |card| turn.trade >= card.cost }
      end
    end
  end
end
