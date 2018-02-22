
module Realms
  module Effects
    class Draw < Numeric
      def execute
        turn.active_player.draw(num)
      end
    end
  end
end
