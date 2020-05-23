module Realms
  module Choices
    class MultiChoice < Choice
      attr_reader :count

      def initialize(subject, options, count:)
        super(subject, options)
        @count = count
      end

      def decision
        @decision ||= Decision.new(count)
      end

      def decide(key)
        option = options_hash.fetch(key) { raise InvalidOption, "missing #{key} in #{options_hash.keys}" }
        options_hash.delete(key) unless option.noop?
        decision.make(option)
        decision
      end

      class Decision
        def initialize(count)
          @count = count
          @chosen_options = []
        end

        def make(option)
          chosen_options << option
        end

        def result
          chosen_options.reject(&:noop?).map(&:value)
        end

        def undecided?
          chosen_options.length != count
        end

        def actionable?
          return false if undecided?
          !chosen_options.all?(&:noop?)
        end

        def clear
          @decision = [] unless undecided?
        end

        private

        attr_reader :count, :chosen_options
      end
    end
  end
end
