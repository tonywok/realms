require "realms2/yielder"
require "realms2/player"
require "realms2/turn"
require "realms2/trade_deck"

module Realms2
  class Game < Yielder
    attr_reader :p1, :p2, :active_turn

    def initialize
      @p1 = Player.new("frog")
      @p2 = Player.new("bear")
      @trade_deck = TradeDeck.new
    end

    def start
      p1.draw(3)
      p2.draw(5)
      next_choice
    end

    def execute
      players = [p1, p2]

      players.cycle do |active_player|
        passive_player = players - [active_player]
        @active_turn = Turn.new(self, active_player, passive_player)
        perform @active_turn
      end
    end

    def inspect
      "Game"
    end
  end
end
