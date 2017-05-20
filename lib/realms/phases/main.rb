module Realms
  module Phases
    class Main < Phase
      delegate :active_player, :passive_player, :trade_deck,
        to: :turn

      def execute
        choose Choice.new(player_actions) do |decision|
          perform decision
          execute unless decision.is_a?(Actions::EndMainPhase)
        end
      end

      def player_actions
        # TODO: roll these up to trade_deck and player
        active_player.hand.actions +
          trade_deck.trade_row.actions +
          active_player.in_play.actions +
          passive_player.in_play.actions +
          trade_deck.explorers.actions +
          [Actions::EndMainPhase.new(turn)]
      end
    end
  end
end
