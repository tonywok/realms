module Realms
  module Effects
    class Discard < Effect
      def execute
        turn.passive_player.upkeep << ::Realms::Actions::Discard
      end
    end
  end
end
