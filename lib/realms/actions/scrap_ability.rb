module Realms
  module Actions
    class ScrapAbility < Action
      def self.key
        :scrap_ability
      end

      def execute
        begin
        card.player.deck.battlefield.delete(card)
        perform card.scrap_ability
        card.player = Player::Unclaimed.instance
        # TODO: put explorers back
        rescue
          byebug
        end
      end
    end
  end
end
