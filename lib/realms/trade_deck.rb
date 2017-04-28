require "realms/sets"

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
        @draw_pile = Zones::Zone.new(self, Sets::Vanilla.new(self).cards),
        @scrap_heap = Zones::Zone.new(self),
        @trade_row = Zones::TradeRow.new(self),
        @explorers = Zones::Explorers.new(self, 10.times.map { |i| Cards::Explorer.new(self, index: i) }),
      ]
      draw_pile.shuffle!(random: game.rng)
      5.times { draw_pile.transfer!(to: trade_row) }
    end

    def scrap(card)
      trade_row.transfer!(card: card, to: scrap_heap)
    end
  end
end
