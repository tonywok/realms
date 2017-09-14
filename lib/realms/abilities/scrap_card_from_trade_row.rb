module Realms
  module Abilities
    class ScrapCardFromTradeRow < Ability
      def self.key
        :scrap_card_from_trade_row
      end

      def execute
        may_choose(cards_in_trade_row) do |card|
          turn.trade_deck.scrap(card)
        end
      end

      def cards_in_trade_row
        turn.trade_deck.trade_row.cards
      end
    end
  end
end
