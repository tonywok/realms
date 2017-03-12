module Realms
  module Actions
    class AllyAbility < Action
      attr_reader :card

      def self.key
        :ally_ability
      end

      def execute
        choose Choice.new(cards_with_unused_ally) do |card|
          perform card.ally_ability
          turn.activated_ally_ability << card
        end
      end

      def cards_with_unused_ally
        active_player.deck.battlefield.select do |card|
          turn.activated_ally_ability.exclude?(card)
        end
      end
    end
  end
end
