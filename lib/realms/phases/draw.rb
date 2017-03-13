module Realms
  module Phases
    class Draw < Phase
      def execute
        turn.active_player.draw(5)
      end
    end
  end
end
