module Realms
  module Abilities
    class Draw < Ability
      def self.key
        :draw
      end

      def execute
        turn.active_player.draw(arg)
      end
    end
  end
end
