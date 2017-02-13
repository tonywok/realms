module Realms2
  class Yielder
    attr_reader :current_choice

    def state_machine
      @state_machine ||= Enumerator.new do |yielder|
        @choices = yielder
        execute
        @choices = nil
      end.lazy.flat_map { |x| x }
    end

    def decide(*decision_key)
      current_choice.decide(decision_key)
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

    def choose(choice)
      choice.clear
      choices.yield choice
      choice.decision
    end

    def perform(choosable)
      choices.yield choosable.state_machine
    end
  end
end
