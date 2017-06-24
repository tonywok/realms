module Realms
  module Actions
    class PlayCard < Action
      def self.key
        :play
      end

      def execute
        active_player.deck.play(card)
        perform card.primary_ability if card.automatic_primary_ability?
        active_player.in_play.automatic_actions.each do |action|
          perform action
        end
      end
    end
  end
end
