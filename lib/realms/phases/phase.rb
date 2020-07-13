module Realms
  module Phases
    class Phase
      attr_reader :turn

      delegate :active_player, :passive_player, :trade_deck,
        to: :turn
      delegate :game, to: :turn
      delegate :choose, :may_choose, :choose_many, :may_choose_many, :perform, to: :game

      def initialize(turn)
        @turn = turn
      end
    end
  end
end
