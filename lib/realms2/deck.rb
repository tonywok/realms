require "realms2/cards"

module Realms2
  class Deck
    attr_reader :draw_pile,
                :hand,
                :discard_pile,
                :battlefield

    class InvalidTarget < StandardError; end

    delegate :include?, to: :cards

    def initialize(player)
      scouts = 8.times.map { Cards::Scout.new(player) }
      vipers = 2.times.map { Cards::Viper.new(player) }
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
      Deck
        hand         : #{hand}
        draw_pile    : #{draw_pile}
        discard_pile : #{discard_pile}
        battlefield  : #{battlefield}
      DECK
    end
  end
end
