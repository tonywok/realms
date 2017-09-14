module Realms
  module Choices
    class Choice
      attr_reader :subject, :options

      def initialize(subject, options)
        @subject = subject
        @options = options
      end

      delegate :undecided?, :clear, :actionable?,
        to: :decision

      def decision
        @decision ||= Decision.new
      end

      def decide(key)
        option = options_hash.fetch(key) { raise InvalidOption, "missing #{key} in #{options_hash.keys}" }
        decision.make(option)
      end

      def noop?
        options.all?(&:noop?)
      end

      def options_hash
        @options_hash ||= options.each_with_object({}) do |option, opts|
          key = [subject, option.key].compact.join(".").to_sym
          opts[key] = option
        end
      end

      def inspect
      end

      class Decision
        def initialize
          self.chosen_option = nil
        end

        def make(chosen_option)
          self.chosen_option = chosen_option
        end

        def result
          chosen_option.value
        end

        def undecided?
          chosen_option.nil?
        end

        def actionable?
          return true if undecided?
          !chosen_option.noop?
        end

        def clear
          self.chosen_option = nil
        end

        private
        attr_accessor :chosen_option
      end
    end
  end
end
