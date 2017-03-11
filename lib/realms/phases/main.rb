require "realms/player_action"

module Realms
  module Phases
    class Main < Phase
      def execute
        action = choose PlayerAction.new(turn)
        perform action
        unless action.is_a?(Actions::EndMainPhase)
          execute
        end
        turn.event_manager.changed
        turn.event_manager.notify_observers(self)
      end
    end
  end
end
