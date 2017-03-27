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
      draw_pile.shuffle!
      5.times do
        ZoneTransfer.new(source: draw_pile, destination: trade_row).transfer!
      end
      ZoneTransfer.subscribe(self)
    end

    def scrap(card)
      ZoneTransfer.new(card: card, source: trade_row, destination: scrap_heap).transfer!
    end

    def zone_transfer(zt)
      if zt.source == trade_row
        pos = trade_row.index(zt.card)
        ZoneTransfer.new(card: draw_pile.first, source: draw_pile, destination: trade_row).transfer!(pos)
      end
    end
  end
end
