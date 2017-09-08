module Realms
  module Phases
    class Setup < Phase
      def execute
        trade_deck.setup
        active_player.draw(3)
        passive_player.draw(5)
      end
    end
  end
end
