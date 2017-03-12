module Realms
  module Actions
    class BaseAbility < Action
      attr_reader :card

      def self.key
        :base_ability
      end

      def execute
        choose Choice.new(bases_with_unused_primary) do |base|
          perform base.primary_ability
          turn.activated_base_ability << base
        end
      end

      def bases_with_unused_primary
        active_player.deck.battlefield.select do |card|
          card.base? && turn.activated_base_ability.exclude?(card)
        end
      end
    end
  end
end
