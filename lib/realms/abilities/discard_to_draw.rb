module Realms
  module Abilities
    class DiscardToDraw < Ability
      def self.key
        :discard_to_draw
      end

      def execute
        may_choose_many(cards_in_hand, count: arg) do |cards|
          cards.each do |card|
            active_player.discard(card)
          end
          active_player.draw(cards.length)
        end
      end

      private

      def cards_in_hand
        turn.active_player.hand.cards
      end
    end
  end
end
