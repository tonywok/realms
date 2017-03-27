module Realms
  module Actions
    class ScrapAbility < Action
      def self.key
        :scrap_ability
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
