module Realms2
  class Choice
    attr_reader :options, :decision

    def initialize(options)
      @options = options
    end

    def decide(option_id)
      @decision = options.fetch(option_id) { raise "nope" }
    end

    def undecided?
      @decision.nil?
    end

    def clear
      @decision = nil
    end
  end
end
