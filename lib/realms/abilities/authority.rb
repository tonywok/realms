module Realms
  module Abilities
    class Authority < Ability
      def execute
        turn.active_player.authority += arg
      end
    end
  end
end
