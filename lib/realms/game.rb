require "realms/yielder"
require "realms/choice"
require "realms/zones"
require "realms/player"
require "realms/turn"
require "realms/trade_deck"

module Realms
  class Game < Yielder
    attr_reader :players, :active_turn, :turn_checkpoint, :trade_deck, :seed, :p1, :p2, :starter_deck

    delegate :active_player, :passive_player,
      to: :active_turn

    delegate :scout, :viper,
      to: :starter_deck

    include Brainguy::Observable
    include Brainguy::Observer

    def initialize(seed: Random.new_seed, turn_checkpoint: 0)
      @seed = seed
      @turn_checkpoint = turn_checkpoint
      @trade_deck = TradeDeck.new(self)
      @starter_deck = StarterDeck.new
      @players = [
        Player.new(self, "frog"),
        Player.new(self, "bear"),
      ]
      @active_turn = Turn.first(self)
      @p1 = active_turn.active_player
      @p2 = active_turn.passive_player
    end

    def on_card_removed(event)
      emit(:card_moved, event.args[0])
    end

    def rng
      Random.new(seed)
    end

    def start
      active_player.draw(3)
      passive_player.draw(5)
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

    class StarterDeck
      attr_reader :scout_count, :viper_count

      def initialize
        @scout_count = 0
        @viper_count = 0
      end

      def scout(player)
        Cards::Scout.new(player, index: scout_count).tap { @scout_count += 1 }
      end

      def viper(player)
        Cards::Viper.new(player, index: viper_count).tap { @viper_count += 1 }
      end
    end
  end
end
