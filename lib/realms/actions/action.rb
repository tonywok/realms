module Realms
  module Actions
    class Action < Yielder
      attr_reader :turn

      delegate :active_player, to: :turn

      def initialize(turn)
        @turn = turn
      end

      def execute
      end
    end
  end
end
