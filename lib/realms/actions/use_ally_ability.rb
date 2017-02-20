module Realms
  module Actions
    class UseAllyAbility < Action
      attr_reader :card

      def initialize(card)
        @card = card
      end

      def execute
        perform card.ally_ability
        card.player.active_turn.activated_ally_ability << card.key
      end
    end
  end
end
