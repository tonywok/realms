module Realms
  module Actions
    class PlayCard < Action
      def self.key
        :play
      end

      def execute
        active_player.play(card)
        perform card.primary_ability(turn) if card.automatic_primary_ability?
        active_player.in_play.actions.select(&:auto?).each do |action|
          perform action
        end
      end
    end
  end
end
