module Realms2
  module Actions
    class UseAllyAbility < Action
      attr_reader :card

      def initialize(card)
        @card = card
      end

      def execute
      end
    end
  end
end
