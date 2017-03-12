module Realms
  module Actions
    class PlayCard < Action
      def self.key
        :play
      end

      def execute
        choose Choice.new(cards_in_hand) do |card|
          active_player.deck.play(card)
          perform card.primary_ability unless card.base?
        end
      end

      def cards_in_hand
        active_player.deck.hand
      end
    end
  end
end
