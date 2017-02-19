module Realms2
  module Actions
    class UseAllyAbility < Action
      attr_reader :card

      def initialize(card)
        @card = card
      end

      def execute
        perform card.ally_ability
      end
    end
  end
end
