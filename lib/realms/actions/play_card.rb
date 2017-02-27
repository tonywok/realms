module Realms
  module Actions
    class PlayCard < Action
      attr_reader :card

      def initialize(card)
        @card = card
      end

      def execute
        card.player.deck.play(card)
        perform card.primary_ability unless card.base?
      end
    end
  end
end
