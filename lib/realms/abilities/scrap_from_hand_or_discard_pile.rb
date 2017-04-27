module Realms
  module Abilities
    class ScrapFromHandOrDiscardPile < Ability
      def self.key
        :scrap_from_hand_or_discard_pile
      end

      def execute
        choose(Choice.new(cards_in_hand_or_discard_pile, optional: optional)) do |card|
          active_player.deck.scrap(card)
        end
      end

      def cards_in_hand_or_discard_pile
        turn.active_player.deck.hand.cards + turn.active_player.deck.discard_pile.cards
      end
    end
  end
end
