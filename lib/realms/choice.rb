module Realms
  class Choice
    class InvalidOption < StandardError; end

    attr_reader :options, :decision

    class NullOption
      include Singleton

      def key
        :none
      end
      alias_method :inspect, :key
    end

    def initialize(options, name: nil, optional: false)
      opts = options
      opts = opts + [NullOption.instance] if optional
      @options = opts.index_by(&:key).transform_keys do |key|
        [name, key].compact.join(".").to_sym
      end
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

    def actionable?
      return false unless decided?
      decision != NullOption.instance
    end

    def clear
      @decision = nil
    end
  end

  class MultiChoice < Choice
    attr_reader :count

    def initialize(options, name: nil, count:)
      super(options, name: name, optional: true)
      @count = count
      @decision = []
    end

    def decide(key)
      @decision << options.delete(key) do
        raise InvalidOption, "missing #{key} in #{options.keys}"
      end
    end

    def decided?
      @decision.length == count
    end

    def decision
      @decision.reject { |o| o.key == :none }
    end

    def actionable?
      return false unless decided?
      decision.none? { |a| a == NullOption.instance }
    end

    def clear
      @decision = [] if decided?
    end
  end
end
