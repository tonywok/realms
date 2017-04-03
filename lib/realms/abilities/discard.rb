module Realms
  module Abilities
    class Discard < Ability
      def self.key
        :discard
      end

      def execute
        turn.passive_player.upkeep << Actions::Discard
      end
    end
  end
end
