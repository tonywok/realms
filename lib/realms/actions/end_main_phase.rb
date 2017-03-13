module Realms
  module Actions
    class EndMainPhase < Action
      def self.key
        :end_turn
      end

      def key
        self.class.key.to_s
      end

      def execute
        turn.event_manager.changed
        turn.event_manager.notify_observers(self)
      end
    end
  end
end
