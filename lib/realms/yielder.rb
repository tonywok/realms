require "realms/choices"

module Realms
  class Yielder
    module Gutted
      delegate :game, to: :turn
      delegate :choose, :perform, to: :game
    end

    attr_reader :current_choice

    def state_machine
      @state_machine ||= Enumerator.new do |yielder|
        @choices = yielder
        __execute
        @choices = nil
      end.lazy.flat_map { |x| x }
    end

    def decide(decision_key)
      current_choice.decide(decision_key.to_sym)
      next_choice
    end

    def next_choice
      return current_choice if current_choice && current_choice.undecided?
      @current_choice = state_machine.next
    rescue StopIteration
      @current_choice = nil
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def key
      self.class.name
    end

    private

    module Callbacks
      extend ActiveSupport::Concern

      included do
        include ActiveSupport::Callbacks

        define_callbacks :execute
        set_callback :execute, :after, :notify


        def __execute
          run_callbacks :execute do
            execute
          end
        end

        def notify; end
      end
    end
    include Callbacks

    attr_reader :choices

    def perform(yielder)
      choices.yield yielder.state_machine
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

    def choose(options, **kwargs)
      choice = choice_factory.make(options, **kwargs)

      return if choice.noop?
      choice.clear
      choices.yield(choice)

      if block_given? && choice.actionable?
        yield(choice.decision.result)
      else
        choice.decision.result
      end
    end

    def choice_factory
      @choice_factory ||= Choices::Factory.new
    end
  end
end
