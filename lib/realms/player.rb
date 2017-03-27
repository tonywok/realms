require "realms/deck"

module Realms
  class Player
    class Unclaimed
      include Singleton
    end

    attr_reader :game, :name, :deck
    attr_accessor :authority

    delegate :active_turn, :trade_deck,
      to: :game

    delegate :draw_pile, :hand, :discard_pile, :battlefield,
      to: :deck

    def initialize(game, name)
      @game = game
      @name = name
      @authority = 50
      @deck = Deck.new(self)
    end

    alias_method :key, :name

    def draw(n)
      n.times { deck.draw }
    end

    def to_s
      @name
    end
  end
end
