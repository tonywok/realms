module Realms
  class TradeDeck
    attr_accessor :draw_pile,
                  :scrap_heap,
                  :trade_row,
                  :explorers

    delegate :include?,
      to: :trade_row

    def initialize(game)
      @draw_pile = 100.times.map { Cards::Scout.new }
      @scrap_heap = []
      @trade_row = []
      @explorers = 10.times.map { |i| Cards::Explorer.new(index: i) }
      draw_pile.shuffle!
      5.times { self.trade_row << draw_pile.shift }
    end

    def scrap(card)
      raise(InvalidTarget, card) unless trade_row.include?(card)
      trade_row[trade_row.index(card)] = draw_pile.shift
      self.scrap_heap << card
    end

    def acquire(card)
      raise(InvalidTarget, card) unless trade_row.include?(card)
      trade_row[trade_row.index(card)] = draw_pile.shift
      card
    end
  end
end
