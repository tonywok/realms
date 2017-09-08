module Realms
  module Actions
    class BaseAbility < Action
      def self.key
        :base_ability
      end

      def execute
        perform card.primary_ability(turn)
      end
    end
  end
end
