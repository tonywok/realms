module Realms
  module Abilities
    class DiscardToDraw < Ability
      def self.key
        :discard_to_draw
      end

      def execute
        choose(MultiChoice.new(cards_in_hand, count: arg)) do |cards|
          cards.each do |card|
            active_player.hand.transfer!(card: card, to: active_player.discard_pile)
          end
          cards.length.times { active_player.draw_pile.transfer!(to: active_player.hand) }
        end
      end

      private

      def cards_in_hand
        turn.active_player.hand.cards
      end
    end
  end
end
