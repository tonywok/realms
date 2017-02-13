module Realms2
  module Abilities
    class Combat < Ability
      def execute
        player.active_turn.combat += arg
      end
    end
  end
end
