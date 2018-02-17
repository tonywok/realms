module Realms
  module Effects
    class ScrapFromHandOrDiscardPile < Effect
      def execute
        choose(cards_in_hand_or_discard_pile, optionality: optional) do |card|
          active_player.scrap(card)
        end
      end

      private

      def cards_in_hand_or_discard_pile
        active_player.hand.cards + active_player.discard_pile.cards
      end
    end
  end
end
