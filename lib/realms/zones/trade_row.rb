module Realms
  module Zones
    class TradeRow < Zone
      def on_card_removed(zt)
        owner.draw_pile.transfer!(to: self, pos: zt.source_position)
      end

      def actions(turn)
        cards.each_with_object([]) do |card, actions|
          if turn.trade >= card.cost
            actions << Actions::AcquireCard.new(turn, card)
          end
        end
      end
    end
  end
end
