require "realms2/player_action"

module Realms2
  module Phases
    class Main < Phase
      def execute
        action = choose PlayerAction.new(turn)
        perform action
        unless action.is_a?(Actions::EndTurn)
          execute
        end
      end
    end
  end
end
