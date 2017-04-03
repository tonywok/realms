module Realms
  module Phases
    class Upkeep < Phase
      def execute
        turn.active_player.upkeep.each do |action|
          perform action.new(turn)
        end
      end
    end
  end
end
