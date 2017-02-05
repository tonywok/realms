require "realms2/yielder"
require "realms2/player"
require "realms2/turn"
require "realms2/trade_deck"

module Realms2
  class Game < Yielder
    attr_reader :p1, :p2

    def initialize
      @p1 = Player.new("frog")
      @p2 = Player.new("bear")
      @trade_deck = TradeDeck.new
    end

    def execute
      players = [p1, p2]

      players.cycle do |active_player|
        passive_player = players - [active_player]
        perform Turn.new(self, active_player, passive_player)
      end
    end
  end
end
