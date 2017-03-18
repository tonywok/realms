module Realms
  module Actions
    class AcquireCard < Action
      include Wisper::Publisher

      attr_accessor :zone

      def self.key
        :acquire
      end

      def initialize(turn, target)
        super
        @zone = :discard_pile
      end

      def execute
        turn.trade -= card.cost
        broadcast(:card_acquired, self)
        turn.trade_deck.acquire(card)
        turn.active_player.deck.acquire(card, zone: zone)
      end
    end
  end
end
