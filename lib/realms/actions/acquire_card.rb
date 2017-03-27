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
        zt = ZoneTransfer.new(card: card, source: turn.trade_deck.trade_row, destination: active_player.deck.discard_pile)
        zt.transfer!
      end
    end
  end
end
