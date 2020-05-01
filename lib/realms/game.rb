require "realms/zones"
require "realms/turn"
require "realms/phases"

module Realms
  class Game < Yielder
    attr_reader :seed, :registry, :event_counter, :active_turn

    delegate :active_player, :passive_player,
      to: :active_turn, allow_nil: true

    delegate :p1, :p2, :trade_deck,
      to: :registry

    def initialize(seed: Random.new_seed)
      @seed = seed
      @registry = Zones::Registry.new(self)
      @event_counter = (0...Float::INFINITY).lazy
      registry.register!
    end

    def start
      self.active_turn = Turn.first(self)
      next_choice
    end

    def over?
      [p1, p2].any? { |p| p.authority <= 0 }
    end

    def execute
      perform Phases::Setup.new(active_turn)

      until over?
        perform Phases::Upkeep.new(active_turn)
        perform Phases::Main.new(active_turn)
        perform Phases::Discard.new(active_turn)
        perform Phases::Draw.new(active_turn)
        next_turn
      end
    end

    def publish(event, **kwargs)
      event_name = key_for(event)
      event_id = event_counter.next
      ActiveSupport::Notifications.instrument(event_name, id: event_id, **kwargs)
    end

    def subscribe
      ActiveSupport::Notifications.subscribe(/^game:#{seed}/) do |event|
        yield Realms::Effects::Event.new(event)
      end
    end

    def key_for(event_name)
      [namespace, event_name].join(".")
    end

    ## Decisions
    #
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
      decide(:primary_ability, card)
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

    def discard(key)
      decide(:discard, key)
    end

    def end_turn
      decide(:end_turn)
    end

    def inspect
      "Game"
    end

    private

    attr_writer :active_turn

    def namespace
      "game:#{seed}.turn:#{active_turn&.id || 0}"
    end

    def next_turn
      self.active_turn = active_turn.next
    end

    def safe(key_or_thing)
      key_or_thing.respond_to?(:key) ? key_or_thing.key : key_or_thing
    end
  end
end
