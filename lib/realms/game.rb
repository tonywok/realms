require "realms/yielder"
require "realms/player"
require "realms/turn"
require "realms/trade_deck"

module Realms
  class Game < Yielder
    attr_reader :p1, :p2, :players, :active_turn, :trade_deck

    def initialize
      @p1 = Player.new(self, "frog")
      @p2 = Player.new(self, "bear")
      @players = [@p1, @p2]
      @trade_deck = TradeDeck.new(self)
    end

    def start
      p1.draw(3)
      p2.draw(5)
      next_choice
      self
    end

    def over?
      players.any? { |p| p.authority <= 0 }
    end

    def execute
      players.cycle do |active_player|
        passive_player = (players - [active_player]).first
        @active_turn = Turn.new(active_player, passive_player, trade_deck)
        perform @active_turn
        break if over?
      end
    end

    def active_player
      active_turn.active_player
    end

    def play(key)
      decide("play.#{safe(key)}")
    end

    def base_ability(key)
      decide("base_ability.#{safe(key)}")
    end

    def ally_ability(key)
      decide("ally_ability.#{safe(key)}")
    end

    def scrap_ability(key)
      decide("scrap_ability.#{safe(key)}")
    end

    def acquire(key)
      decide("acquire.#{safe(key)}")
    end

    def attack(key)
      decide("attack.#{safe(key)}")
    end

    def safe(key_or_thing)
      key_or_thing.respond_to?(:key) ? key_or_thing.key : key_or_thing
    end

    def end_turn
      decide("end_turn")
    end

    def inspect
      "Game"
    end
  end
end
