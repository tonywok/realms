module Realms
  module Actions
    class UseCombat < Action
      def execute
        turn.passive_player.authority -= turn.combat
        turn.combat = 0
      end
    end
  end
end
