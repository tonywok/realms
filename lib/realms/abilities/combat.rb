module Realms
  module Abilities
    class Combat < Ability
      def execute
        turn.combat += arg
      end
    end
  end
end
