module Realms
  module Actions
    class EndMainPhase < Action
      def self.key
        :end_turn
      end

      def key
        self.class.key.to_s
      end
    end
  end
end
