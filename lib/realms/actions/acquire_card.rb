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
        turn.trade_deck.trade_row.transfer!(card: card, to: active_player.discard_pile)
      end
    end
  end
end
