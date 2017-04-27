module Realms
  module Abilities
    class TopDeckNextShip < Ability
      def self.key
        :top_deck_next_ship
      end

      def execute
        trade_deck.trade_row.on(:before_card_removed) do |zt|
          if zt.card.ship? && @once.nil?
            zt.destination = active_player.deck.draw_pile
            zt.destination_position = 0
            @once = true # NOTE: hack since you can't unsubscribe?!
          end
        end
      end
    end
  end
end
