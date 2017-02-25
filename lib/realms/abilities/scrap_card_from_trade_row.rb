module Realms
  module Abilities
    class ScrapCardFromTradeRow < Ability
      def execute
        choose(Choice.new(cards_in_trade_row, optional: optional)) do |card|
          turn.active_player.trade_deck.scrap(card)
        end
      end

      def cards_in_trade_row
        turn.trade_deck.trade_row.each_with_object({}) do |card, opts|
          opts[card.key] = card
        end
      end
    end
  end
end
