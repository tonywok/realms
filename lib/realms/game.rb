require "realms/yielder"
require "realms/choice"
require "realms/zones"
require "realms/player"
require "realms/turn"
require "realms/trade_deck"

module Realms
  class Game < Yielder
    attr_reader :players, :active_turn, :trade_deck, :seed, :p1, :p2, :starter_deck

    delegate :active_player, :passive_player,
      to: :active_turn

    delegate :scout, :viper,
      to: :starter_deck

    include Brainguy::Observable
    include Brainguy::Observer

    def initialize(seed: Random.new_seed)
      @seed = seed
      @starter_deck = StarterDeck.new
      @trade_deck = TradeDeck.new(self)
      @players = ["p1", "p2"].shuffle(random: rng).map do |key|
        instance_variable_set("@#{key}", Player.new(self, key))
      end
      @active_turn = Turn.first(trade_deck, p1, p2)
    end

    def start
      p1.draw(3)
      p2.draw(5)
      next_choice
      self
    end

    def on_card_removed(event)
      emit(:card_moved, event.args[0])
    end

    def rng
      Random.new(seed)
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

    def decide(*args)
      action, key = args
      if args.many?
        super([action, safe(key)].compact.join("."))
      else
        super(safe(action))
      end
    end

    def play(card)
      decide(:play, card)
    end

    def base_ability(card)
      decide(:base_ability, card)
    end

    def ally_ability(card)
      decide(:ally_ability, card)
    end

    def scrap_ability(card)
      decide(:scrap_ability, card)
    end

    def acquire(card)
      decide(:acquire, card)
    end

    def attack(key)
      decide(:attack, key)
    end

    def end_turn
      decide(:end_turn)
    end

    def inspect
      "Game"
    end

    private

    def safe(key_or_thing)
      key_or_thing.respond_to?(:key) ? key_or_thing.key : key_or_thing
    end

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
