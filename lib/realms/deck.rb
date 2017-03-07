require "realms/cards"

module Realms
  class Deck
    attr_accessor :draw_pile,
                  :hand,
                  :discard_pile,
                  :battlefield,
                  :player

    delegate :include?, to: :cards

    def initialize(player)
      @player = player
      scouts = 8.times.map { |i| Cards::Scout.new(player, index: i) }
      vipers = 2.times.map { |i| Cards::Viper.new(player, index: i) }
      @draw_pile = scouts + vipers
      @discard_pile = []
      @hand = []
      @battlefield = []
    end

    def cards
      draw_pile + discard_pile + hand + battlefield
    end

    def discard(card)
      raise(InvalidTarget, card) unless hand.include?(card)
      self.discard_pile << self.hand.delete_at(hand.index(card) || hand.length)
    end

    def play(card)
      raise(InvalidTarget, card) unless hand.include?(card)
      self.battlefield << self.hand.delete_at(hand.index(card) || hand.length)
    end

    def acquire(card, zone: :discard_pile)
      card.player = player
      self.send(zone).unshift(card)
    end

    def scrap(card)
      raise(InvalidTarget, card) unless include?(card)
      # NOTE: so zone is a thing I need to extract
      zone = [draw_pile, discard_pile, hand, battlefield].find do |z|
        z.include?(card)
      end
      zone.delete(card)
    end

    def destroy(card)
      raise(InvalidTarget, card) unless battlefield.include?(card)
      self.discard_pile << self.battlefield.delete_at(battlefield.index(card) || battlefield.length)
    end

    def discard_hand
      until hand.empty?
        discard(hand.first)
      end
    end

    def draw
      if draw_pile.empty?
        reshuffle
        draw unless draw_pile.empty?
      else
        self.hand << draw_pile.shift
      end
    end

    def reshuffle
      until discard_pile.empty? do
        self.draw_pile << discard_pile.shift
      end
      draw_pile.shuffle!
    end

    def inspect
      <<-DECK
      hand         : #{hand}
      draw_pile    : #{draw_pile}
      discard_pile : #{discard_pile}
      battlefield  : #{battlefield}
      DECK
    end
  end
end
