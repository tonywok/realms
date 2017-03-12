module Realms
  module Actions
    class ScrapAbility < Action
      attr_reader :card

      def self.key
        :scrap_ability
      end

      def execute
        choose Choice.new(cards_with_scrap_ability) do |card|
          card.player.deck.battlefield.delete(card)
          perform card.scrap_ability
          card.player = Player::Unclaimed.instance
          # TODO: put explorers back
        end
      end

      def cards_with_scrap_ability
        active_player.deck.battlefield.select(&:scrap_ability?)
      end
    end
  end
end
