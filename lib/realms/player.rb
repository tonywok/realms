require "realms/deck"

module Realms
  class Player
    attr_reader :game, :deck, :upkeep, :key
    attr_accessor :authority

    delegate :active_turn, :trade_deck,
      to: :game
    delegate :draw_pile, :hand, :discard_pile, :in_play, :zones,
      to: :deck

    def initialize(game, key)
      @key = key
      @game = game
      @authority = 50
      @deck = Deck.new(self)
      @upkeep = []
    end

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
      "<Player #{key}: authority=#{authority}>"
    end
  end
end

