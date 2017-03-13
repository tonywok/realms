module Realms
  module Actions
    class AllyAbility < Action
      def self.key
        :ally_ability
      end

      def execute
        perform card.ally_ability
        turn.activated_ally_ability << card
      end
    end
  end
end
