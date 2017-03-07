module Realms
  module Abilities
    class ScrapFromHandOrDiscardPile < Ability
      def execute
        arg.times do
          choose(Choice.new(cards_in_hand_or_discard_pile, optional: optional)) do |card|
            turn.trade_deck.scrap_heap << turn.active_player.deck.scrap(card)
          end
        end
      end

      def cards_in_hand_or_discard_pile
        cards_in_hand = turn.active_player.deck.hand
        cards_in_discard_pile = turn.active_player.deck.discard_pile

        (cards_in_hand + cards_in_discard_pile).each_with_object({}) do |card, opts|
          opts[card.key] = card
        end
      end
    end
  end
end
