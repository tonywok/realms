require "realms2/cards"

module Realms2
  class Deck
    attr_reader :draw_pile,
                :hand,
                :discard_pile,
                :battlefield

    def initialize(player)
      scouts = 7.times.map { Cards::Scout.new(player) }
      vipers = 3.times.map { Cards::Viper.new(player) }
      @draw_pile = scouts + vipers
      @discard_pile = []
      @hand = []
      @battlefield = []
    end

    def include?(card)
      [:draw_pile,
       :discard_pile,
       :hand,
       :battlefield,
      ].any? { |zone| send(zone).include?(card) }
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
