module Realms
  class TradeDeck
    attr_reader :key

    def initialize(registry)
      @key = "trade_deck"
      @registry = registry
    end

    def scrap(card)
      card.zone.transfer!(card: card, to: scrap_heap)
    end

    def setup
      draw_pile.shuffle!(random: registry.rng)
      5.times { draw_pile.transfer!(to: trade_row) }
    end

    def actions
      zones.flat_map(&:actions)
    end

    def zones
      @zones ||= [
        scrap_heap,
        trade_row,
        explorers,
        draw_pile,
      ]
    end

    def scrap_heap
      @scrap_heap ||= registry.zone("trade_deck.scrap_heap")
    end

    def trade_row
      @trade_row ||= registry.zone("trade_deck.trade_row")
    end

    def explorers
      @explorers ||= registry.zone("trade_deck.explorers")
    end

    def draw_pile
      @draw_pile ||= registry.zone("trade_deck.draw_pile")
    end

    private

    attr_reader :registry
  end
end
