module Realms
  module Phases
    class Phase < Yielder
      attr_reader :turn

      delegate :active_player,
        to: :turn

      def initialize(turn)
        @turn = turn
      end
    end
  end
end
