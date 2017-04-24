module Realms
  class TradeDeck
    attr_accessor :draw_pile,
                  :scrap_heap,
                  :trade_row,
                  :explorers

    delegate :include?,
      to: :trade_row

    def initialize(game)
      @draw_pile = Zone.new(10.times.map { |i| Cards::Cutter.new(index: i) })
      @scrap_heap = Zone.new
      @trade_row = Zone.new
      @explorers = Zone.new(10.times.map { |i| Cards::Explorer.new(index: i) })
      draw_pile.shuffle!(random: game.rng)
      5.times { draw_pile.transfer!(to: trade_row) }
      ZoneTransfer.subscribe(self)
    end

    def scrap(card)
      trade_row.transfer!(card: card, to: scrap_heap)
    end

    def zone_transfer(zt)
      if zt.source == trade_row
        draw_pile.transfer!(to: trade_row, pos: trade_row.index(zt.card))
      end
    end
  end
end
