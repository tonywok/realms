module Realms
  class Choice
    attr_reader :options, :decision

    def initialize(options, optional: false)
      @options = options
      @options[:none] = false if optional
    end

    def decide(args)
      @decision = options.dig(*args).tap do |choice|
        raise "missing #{args.join("::")} in #{options.keys}" if choice.nil?
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
