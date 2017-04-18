module Realms
  class Choice
    class InvalidOption < StandardError; end

    attr_reader :options, :decision

    def initialize(options, optional: false)
      @options = options.each_with_object({}) do |option, opts|
        opts[option.key] = option
      end
      @options[:none] = false if optional
    end

    def decide(key)
      @decision = options.fetch(key) do
        raise InvalidOption, "missing #{key} in #{options.keys}"
      end
    end

    def noop?
      options.except(:none).empty?
    end

    def decided?
      !@decision.nil?
    end

    def clear
      @decision = nil
    end
  end
end
