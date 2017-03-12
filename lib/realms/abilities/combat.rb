module Realms
  module Abilities
    class Combat < Ability
      def self.key
        :combat
      end

      def execute
        turn.combat += arg
      end
    end
  end
end
