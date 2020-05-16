module Realms
  module Phases
    class Phase
      attr_reader :turn

      delegate :active_player, :passive_player, :trade_deck,
        to: :turn

      include Yielder::Gutted

      def initialize(turn)
        @turn = turn
      end
    end
  end
end
