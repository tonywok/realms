module Realms
  module Actions
    class Definition
      attr_reader :key, :execution

      def initialize(name:, auto: false, &execution)
        @name = name
        @auto = @auto
        @execution = execution
      end

      def auto?
        !!@auto
      end

      def evaluate(context)
        Evaluated.new(:definition => self, :context => context)
      end

      # TODO: Rename me (and friends) to Action, Effect, etc...
      class Evaluated
        attr_reader :definition, :context

        delegate :auto?,
          to: :definition
        delegate :target,
          to: :context

        def initialize(definition:, context:)
          @definition = definition
          @context = context
        end

        def key
          [definition.key, target.key].compact.join(".")
        end

        def choose(options, subject: key, **kwargs, &block)
          game.choose(options, subject: subject, **kwargs, &block)
        end

        def execute
          context.instance_exec(definition.execution)
        end
      end
    end
  end
end