module Realms
  module Zones
    class TradeRow < Zone
      def on_card_removed(zt)
        owner.draw_pile.transfer!(to: self, pos: zt.source_position)
      end
    end
  end
end
