require "realms/zones"
require "realms/turns"
require "realms/turn"

module Realms
  class Game
    attr_reader :seed, :event_counter, :active_turn

    delegate :active_player,
      to: :turn_structure

    attr_reader :fiber, :flows, :turn_structure, :layout

    def initialize(seed: Random.new_seed)
      @seed = seed
      @event_counter = (0...Float::INFINITY).lazy
      @flows = []
      @fiber = Fiber.new { execute }
      @layout = Zones.layout.make(GameContext.new(game: self))
      @turn_structure = Turns.structure.evaluate(layout)
      @game_over = false
    end

    def p1
      layout.perspectives.fetch("p1")
    end

    def p2
      layout.perspectives.fetch("p2")
    end

    def over?
      !!@game_over
    end

    ## START

    attr_accessor :_current_choice

    def start
      self.active_turn = Turn.first(self)
      fiber.resume
    end

    def perform(thing)
      flows.push(thing)
      instance_exec { thing.execute }
      flows.pop
    end

    def choose(options, **kwargs)
      choice = choice_factory.make(options, **kwargs)
      return if choice.noop?

      self._current_choice = choice
      choice.clear

      decision = nil
      until !choice.undecided?
        decision = Fiber.yield(choice)
      end

      if block_given? && decision.actionable?
        yield(decision.result)
      else
        decision.result
      end
    end

    def may_choose(options, **kwargs, &block)
      choose(options, optionality: true, **kwargs, &block)
    end

    def choose_many(options, count:, **kwargs, &block)
      choose(options, count: count, **kwargs, &block)
    end

    def may_choose_many(options, count:, **kwargs, &block)
      choose_many(options, count: count, optionality: true, **kwargs, &block)
    end

    def choice_factory
      @choice_factory ||= Choices::Factory.new
    end

    ## END REMOVE ME

    class GameContext
      include Brainguy::Observer
      include Brainguy::Observable

      attr_reader :game, :rng

      delegate :active_turn, :choose,
        :to => :game

      def initialize(game:)
        @game = game
        @rng = Random.new(game.seed)
      end

      def emit(*args)
        super(*args)
      end
    end

    def execute
      catch(:game_over) do
        turn_structure.execute
      end
      @game_over = true
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
      return if over?
      action, key = args
      decision_key = if args.many?
        [action, safe(key)].compact.join(".")
      else
        safe(action)
      end
      decision = _current_choice.decide(decision_key.to_sym)
      fiber.resume(decision)
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
