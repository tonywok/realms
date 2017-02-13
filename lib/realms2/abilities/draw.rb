module Realms2
  module Abilities
    class Draw < Ability
      def execute
        player.draw(arg)
      end
    end
  end
end
