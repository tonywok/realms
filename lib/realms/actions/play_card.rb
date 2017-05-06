module Realms
  module Actions
    class PlayCard < Action
      def self.key
        :play
      end

      def execute
        active_player.deck.play(card)
        perform card.primary_ability if card.ship? || card.static?
        turn.send(:broadcast, :card_played, card)
      end
    end
  end
end
