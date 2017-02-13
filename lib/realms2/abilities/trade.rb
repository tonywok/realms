module Realms2
  module Abilities
    class Trade < Ability
      def execute
        player.active_turn.trade += arg
      end
    end
  end
end
