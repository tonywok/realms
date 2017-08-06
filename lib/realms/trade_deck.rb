require "realms/card_pools"

module Realms
  class TradeDeck
    attr_reader :game
    attr_accessor :draw_pile,
                  :scrap_heap,
                  :trade_row,
                  :explorers,
                  :zones

    delegate :include?,
      to: :trade_row

    delegate :active_turn,
      to: :game

    def initialize(game)
      @game = game
      @zones = [
        @draw_pile = Zones::DrawPile.new(self, CardPools::Vanilla.new(self).cards),
        @scrap_heap = Zones::ScrapHeap.new(self),
        @trade_row = Zones::TradeRow.new(self),
        @explorers = Zones::Explorers.new(self),
      ]
      draw_pile.shuffle!(random: game.rng)
      5.times { draw_pile.transfer!(to: trade_row) }
    end

    def key
      "trade_deck"
    end

    def scrap(card)
      card.zone.transfer!(card: card, to: scrap_heap)
    end
  end
end
