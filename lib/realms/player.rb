require "realms/deck"

module Realms
  class Player
    attr_reader :game, :name, :deck, :upkeep
    attr_accessor :authority

    delegate :active_turn, :trade_deck,
      to: :game

    delegate :draw_pile, :hand, :discard_pile, :in_play, :zones,
      to: :deck

    def initialize(game)
      @game = game
      @authority = 50
      @deck = Deck.new(self)
      @upkeep = []
    end

    alias_method :key, :name

    def draw(n)
      n.times { deck.draw }
    end

    def scout
      game.scout(self)
    end

    def viper
      game.viper(self)
    end

    def to_s
      @name
    end
  end
end

