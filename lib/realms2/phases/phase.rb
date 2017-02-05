require "realms2/player_action"

module Realms2
  module Phases
    class Phase < Yielder
      attr_reader :turn

      def initialize(turn)
        @turn = turn
      end
    end
  end
end
