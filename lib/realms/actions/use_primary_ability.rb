module Realms
  module Actions
    class UsePrimaryAbility < Action
      attr_reader :card

      def initialize(card)
        @card = card
      end

      def execute
        perform card.primary_ability.new(card.player.active_turn)
        card.player.active_turn.activated_base_ability << card.key
      end
    end
  end
end
