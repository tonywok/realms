module Realms
  module Phases
    class Draw < Phase
      def execute
        active_player.draw(5)
        active_player.in_play.reset!
      end
    end
  end
end
