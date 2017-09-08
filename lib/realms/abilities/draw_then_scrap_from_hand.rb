module Realms
  module Abilities
    class DrawThenScrapFromHand < Ability
      def self.key
        :draw_then_scrap_from_hand
      end

      def execute
        active_player.draw(1)
        choose(cards_in_hand)do |chosen_card|
          active_player.hand.transfer!(card: chosen_card, to: turn.trade_deck.scrap_heap)
        end
      end

      def cards_in_hand
        turn.active_player.hand
      end
    end
  end
end
