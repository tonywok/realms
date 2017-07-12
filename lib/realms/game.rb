require "realms/yielder"
require "realms/choice"
require "realms/zones"
require "realms/player"
require "realms/turn"
require "realms/trade_deck"

module Realms
  class Game < Yielder
    attr_reader :players, :active_turn, :trade_deck, :seed

    delegate :active_player, :passive_player,
      to: :active_turn

    def initialize(seed = Random.new_seed)
      @seed = seed
      @trade_deck = TradeDeck.new(self)
      @players = [
        Player.new(self, "frog"),
        Player.new(self, "bear")
      ]
      @active_turn = Turn.first(self)
    end

    def rng
      Random.new(seed)
    end

    def start
      next_choice
      self
    end

    def over?
      players.any? { |p| p.authority <= 0 }
    end

    def execute
      until over?
        perform(@active_turn)
        next_turn
      end
    end

    def decide(key)
      super(safe(key))
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

    private

    def next_turn
      @active_turn = @active_turn.next
    end
  end
end
