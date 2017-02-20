require "realms/deck"

module Realms
  class Player
    class Unclaimed
      include Singleton
    end

    attr_reader :game, :name, :deck

    delegate :active_turn, :trade_deck,
      to: :game

    def initialize(game, name)
      @game = game
      @name = name
      @deck = Deck.new(self)
    end

    def draw(n)
      n.times { deck.draw }
    end

    def to_s
      @name
    end
  end
end
