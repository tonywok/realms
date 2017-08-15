module Realms
  module Phases
    class Upkeep < Phase
      def execute
        active_player.upkeep.each do |action|
          perform action.new(turn)
        end
        active_player.upkeep.clear
      end
    end
  end
end
