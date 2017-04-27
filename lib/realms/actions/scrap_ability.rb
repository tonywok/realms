module Realms
  module Actions
    class ScrapAbility < Action
      def self.key
        :scrap_ability
      end

      def execute
        active_player.deck.scrap(card)
        perform card.scrap_ability
        # TODO: put explorers back
      end
    end
  end
end
