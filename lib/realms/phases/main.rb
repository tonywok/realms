module Realms
  module Phases
    class Main < Phase
      delegate :active_player, :passive_player, :trade_deck,
        to: :turn

      def execute
        choose(player_actions) do |decision|
          perform decision
          execute unless decision.is_a?(Actions::EndMainPhase)
        end
      end

      def player_actions
        active_player.actions +
          passive_player.in_play.actions +
          trade_deck.actions +
          [Actions::EndMainPhase.new(turn)]
      end
    end
  end
end
