module Realms
  module Phases
    class Phase < Yielder
      attr_reader :turn

      delegate :active_player, :passive_player, :trade_deck,
        to: :turn

      def initialize(turn)
        @turn = turn
      end
    end
  end
end
