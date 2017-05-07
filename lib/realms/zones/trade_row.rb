module Realms
  module Zones
    class TradeRow < Zone
      def on_card_removed(event)
        owner.draw_pile.transfer!(to: self, pos: event.args.first.source_position)
      end

      def actions
        cards.each_with_object([]) do |card, actions|
          if active_turn.trade >= card.cost
            actions << Actions::AcquireCard.new(active_turn, card)
          end
        end
      end
    end
  end
end
