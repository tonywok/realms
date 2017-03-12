module Realms
  module Phases
    class Main < Phase
      def execute
        choose Choice.new(player_actions) do |decision|
          action = decision.new(turn)
          perform action
          execute unless action.key.end_turn?
        end
      end

      def player_actions
        [
          Actions::PlayCard,
          Actions::BaseAbility,
          Actions::AllyAbility,
          Actions::ScrapAbility,
          Actions::AcquireCard,
          Actions::Attack,
          Actions::EndMainPhase,
        ]
      end
    end
  end
end
