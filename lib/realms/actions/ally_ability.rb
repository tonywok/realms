module Realms
  module Actions
    class AllyAbility < Action
      def self.key
        :ally_ability
      end

      def auto?
        card.automatic_ally_ability?
      end

      def execute
        perform card.ally_ability
      end
    end
  end
end
