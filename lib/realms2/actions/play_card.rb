module Realms2
  module Actions
    class PlayCard < Action
      attr_reader :card

      def initialize(card)
        @card = card
      end

      def execute
        card.player.deck.play(card)
        perform card.primary_ability
      end
    end
  end
end
