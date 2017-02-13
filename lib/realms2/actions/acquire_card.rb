module Realms2
  module Actions
    class AcquireTradeRowCard < Action
      attr_reader :turn

      def initialize(turn)
        @turn = turn
      end

      def execute
      end
    end
  end
end
