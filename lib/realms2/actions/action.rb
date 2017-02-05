module Realms2
  module Actions
    class Action < Yielder
      attr_reader :turn

      def initialize(turn)
        @turn = turn
      end

      def execute
      end
    end
  end
end
