module Realms
  module Abilities
    class TopDeckNextShip < Ability
      def self.key
        :top_deck_next_ship
      end

      def execute
        ZoneTransfer.subscribe(self)
      end

      def zone_transfer(zt)
        if zt.source == turn.trade_deck.trade_row && zt.card.ship?
          zt.destination = active_player.deck.draw_pile
          zt.position = 0
          Wisper.unsubscribe(self)
        end
      end
    end
  end
end
