module Realms
  module Actions
    class PlayCard < Action
      attr_reader :card

      def initialize(card)
        @card = card
      end

      def execute
        card.player.deck.play(card)
        perform card.primary_ability.new(card.player.active_turn)
      end
    end
  end
end
