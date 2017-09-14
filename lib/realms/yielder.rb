require "realms/choices"

module Realms
  class Yielder
    attr_reader :current_choice

    def state_machine
      @state_machine ||= Enumerator.new do |yielder|
        @choices = yielder
        execute
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

    private

    attr_reader :choices

    def perform(yielder)
      choices.yield yielder.state_machine
    end

    def may_choose(options, **kwargs, &block)
      choose(options, kwargs.merge(optionality: true), &block)
    end

    def choose_many(options, count:, **kwargs, &block)
      choose(options, kwargs.merge(count: count), &block)
    end

    def may_choose_many(options, count:, **kwargs, &block)
      choose_many(options, kwargs.merge(count: count, optionality: true), &block)
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
