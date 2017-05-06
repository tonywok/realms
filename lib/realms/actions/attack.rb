module Realms
  module Actions
    class Attack < Action
      def self.key
        :attack
      end

      def execute
        case target
        when Realms::Player
          turn.passive_player.authority -= turn.combat
          turn.combat = 0
        else
          turn.combat -= target.defense
          passive_player.deck.destroy(target)
        end
      end
    end
  end
end
