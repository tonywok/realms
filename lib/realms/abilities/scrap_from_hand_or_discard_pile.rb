module Realms
  module Abilities
    class ScrapFromHandOrDiscardPile < Ability
      def self.key
        :scrap_from_hand_or_discard_pile
      end

      def execute
        choose(cards_in_hand_or_discard_pile) do |card|
          active_player.scrap(card)
        end
      end

      def cards_in_hand_or_discard_pile
        active_player.hand.cards + active_player.discard_pile.cards
      end
    end
  end
end
