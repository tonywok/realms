module Realms2
  module Actions
    class UseScrapAbility < Action
      attr_reader :card

      def initialize(card)
        @card = card
      end

      def execute
        card.player.deck.battlefield.delete(card)
        perform card.scrap_ability
        card.player = Player::Unclaimed.instance
        # TODO: put explorers back
      end
    end
  end
end
