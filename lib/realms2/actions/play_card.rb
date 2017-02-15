module Realms2
  module Actions
    class PlayCard < Action
      attr_reader :card

      def initialize(card)
        @card = card
      end

      def execute
        card.player.deck.hand.delete(card)
        card.player.deck.battlefield << card
        perform card.primary_ability
      end
    end
  end
end
