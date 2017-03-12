module Realms
  module Abilities
    class ScrapCardFromTradeRow < Ability
      def self.key
        :scrap_card_from_trade_row
      end

      def execute
        choose(Choice.new(cards_in_trade_row, optional: optional)) do |card|
          turn.active_player.trade_deck.scrap(card)
        end
      end

      def cards_in_trade_row
        turn.trade_deck.trade_row
      end
    end
  end
end
