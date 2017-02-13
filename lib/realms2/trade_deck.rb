module Realms2
  class TradeDeck
    attr_accessor :draw_pile,
                  :scrap_heap,
                  :trade_row,
                  :explorers

    def initialize(game)
      @draw_pile = 100.times.map { Cards::Scout.new }
      @scrap_heap = []
      @trade_row = []
      @explorers = 10.times.map { Cards::Explorer.new }
      draw_pile.shuffle!
      5.times { self.trade_row << draw_pile.shift }
    end
  end
end
