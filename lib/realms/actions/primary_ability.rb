module Realms
  module Actions
    class PrimaryAbility < Action
      def self.key
        :primary_ability
      end

      def execute
        perform card.primary_ability(turn)
        active_player.in_play.actions.select(&:auto?).each do |action|
          perform action
        end
      end
    end
  end
end
