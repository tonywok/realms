module Realms
  module Actions
    class Discard < Action
      def self.key
        :discard
      end

      def execute
        choose(cards_in_hand) do |chosen_card|
          active_player.discard(chosen_card)
        end
      end

      private

      def cards_in_hand
        active_player.hand.cards
      end
    end
  end
end
