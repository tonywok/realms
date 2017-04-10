module Realms
  module Abilities
    class DiscardToDraw < Ability
      def self.key
        :discard_to_draw
      end

      def execute
        # TODO: this isn't great. Need multi-choice
        arg.times do
          choose(Choice.new(cards_in_hand, optional: optional)) do |card|
            active_player.hand.transfer!(card: card, to: active_player.discard_pile)
            active_player.draw_pile.transfer!(to: active_player.hand)
          end
        end
      end

      private

      def cards_in_hand
        turn.active_player.hand.cards
      end
    end
  end
end
