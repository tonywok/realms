module Realms2
  class Choice
    attr_reader :options, :decision

    def initialize(options)
      @options = options
    end

    def decide(args)
      @decision = options.dig(*args).tap do |choice|
        raise "missing #{args.join} in #{options.keys}" if choice.nil?
      end
    end

    def undecided?
      @decision.nil?
    end

    def clear
      @decision = nil
    end
  end
end
