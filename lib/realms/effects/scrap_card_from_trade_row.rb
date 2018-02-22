module Realms
  module Effects
    class ScrapCardFromTradeRow < Effect
      def execute
        choose(cards_in_trade_row, optionality: optional) do |card|
          active_player.scrap(card)
        end
      end

      private

      def cards_in_trade_row
        trade_deck.trade_row.cards
      end
    end
  end
end
