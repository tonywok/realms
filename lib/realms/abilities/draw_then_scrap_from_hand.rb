module Realms
  module Abilities
    class DrawThenScrapFromHand < Ability
      def execute
        active_player.draw(1)
        choose Choice.new(cards_in_hand) do |chosen_card|
          turn.trade_deck.scrap_heap << active_player.deck.scrap(chosen_card)
        end
      end

      def cards_in_hand
        turn.active_player.deck.hand
      end
    end
  end
end
