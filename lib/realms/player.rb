module Realms
  class Player
    attr_reader :key, :registry, :upkeep, :authority

    def initialize(key, registry)
      @key = key
      @registry = registry
      @authority = 50
      @upkeep = []
    end

    def authority=(amount)
      (@authority = amount).tap do
        raise(GameOver) if amount <= 0
      end
    end

    def zones
      [
        discard_pile,
        hand,
        draw_pile,
        in_play,
      ]
    end

    def actions
      zones.flat_map(&:actions)
    end

    def scout
      registry.scout(self)
    end

    def viper
      registry.viper(self)
    end

    # TODO:
    # delegate :hand, :discard_pile, :in_play, :draw_pile,
    #   to: :player_zones
    #
    # delegate :trade_row, :scrap_heap, :explorers,
    #   to: :trade_deck_zones

    def discard(card)
      hand.transfer!(card: card, to: discard_pile)
    end

    def play(card)
      hand.transfer!(card: card, to: in_play)
    end

    def destroy(card)
      in_play.transfer!(card: card, to: discard_pile)
    end

    def acquire(card, zone: discard_pile, pos: 0)
      card.zone.transfer!(card: card, to: zone, pos: pos)
    end

    def scrap(card)
      card.zone.transfer!(card: card, to: scrap_heap)
    end

    def discard_hand
      until hand.empty?
        discard(hand.first)
      end
    end

    def draw(num = 1)
      num.times { draw_one }
    end

    def reshuffle
      until discard_pile.empty? do
        discard_pile.transfer!(to: draw_pile)
      end
      draw_pile.shuffle!(random: registry.rng)
    end

    def hand
      @hand ||= registry.zone(my("hand"))
    end

    def discard_pile
      @discard_pile ||= registry.zone(my("discard_pile"))
    end

    def draw_pile
      @draw_pile ||= registry.zone(my("draw_pile"))
    end

    def in_play
      @in_play ||= registry.zone(my("in_play"))
    end

    def trade_row
      @trade_row ||= registry.zone("trade_deck.trade_row")
    end

    def explorers
      @explorers ||= registry.zone("trade_deck.explorers")
    end

    def scrap_heap
      @scrap_heap ||= registry.zone("trade_deck.scrap_heap")
    end

    def to_s
      "<Player #{key}: authority=#{authority}>"
    end

    private

    def my(zone)
      [key, zone].join(".")
    end

    def draw_one
      if draw_pile.empty?
        reshuffle
        draw unless draw_pile.empty?
      else
        draw_pile.transfer!(to: hand)
      end
    end
  end
end
