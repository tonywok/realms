module Realms
  module Actions
    class AcquireExplorer < Action
      attr_reader :turn

      def initialize(turn)
        @turn = turn
      end

      def execute
        explorer = turn.trade_deck.explorers.shift
        turn.trade -= explorer.cost
        explorer.player = active_player
        active_player.deck.discard_pile << explorer
      end
    end
  end
end
