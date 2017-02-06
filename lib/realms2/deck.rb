module Realms2
  class Card
    attr_reader :name, :cost

    def initialize(name:, cost:)
      @name = name
      @cost = cost
    end
  end

  class Deck
    attr_reader :draw_pile,
                :hand,
                :discard_pile,
                :battlefield

    def initialize
      scouts = 7.times.map { Card.new(name: "Scout", cost: 0) }
      vipers = 3.times.map { Card.new(name: "Viper", cost: 0) }
      @draw_pile = scouts + vipers
      @discard_pile = []
      @hand = []
      @battlefield = []
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
  end
end
