require "realms/choice"
require "realms/actions"

module Realms
  class CardFromTradeRow < Choice
    def initialize(turn)
      @options = turn.trade_deck.trade_row.index_by(&:key)
    end
  end

  module Abilities
    class ScrapCardFromTradeRow < Ability
      def execute
        card = choose CardFromTradeRow.new(player.active_turn)
        player.trade_deck.scrap(card)
      end
    end
  end
end
