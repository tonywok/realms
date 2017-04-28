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
        [Actions::EndMainPhase.new(turn)] +
          # TODO: roll these up to trade_deck and player
          trade_deck.trade_row.actions +
          trade_deck.explorers.actions +
          active_player.hand.actions +
          active_player.in_play.actions +
          passive_player.in_play.actions
      end
    end
  end
end
