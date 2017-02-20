require "realms/player_action"

module Realms
  module Phases
    class Phase < Yielder
      attr_reader :turn

      def initialize(turn)
        @turn = turn
      end
    end
  end
end
