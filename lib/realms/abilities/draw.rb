module Realms
  module Abilities
    class Draw < Ability
      def execute
        turn.active_player.draw(arg)
      end
    end
  end
end
