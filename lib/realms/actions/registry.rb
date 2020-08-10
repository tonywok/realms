module Realms
  module Actions
    class Registry
      def self.configure(&block)
        registry = new
        registry.instance_exec(&block)
        registry
      end

      attr_reader :configs

      delegate :slice,
        to: :configs

      def initialize
        @configs = {}
      end

      def action(key, &config)
        builder = Builder.new(key: key)
        builder.instance_exec(&config) if block_given?
        @configs.merge!(key => builder.to_definition) do |_|
          raise("#{key} is already registered")
        end
      end

      class Builder
        attr_accessor :key, :targeting, :execution

        def initialize(key:)
          @key = key
          @targeting = -> { [] }
          @execution = -> { false }
        end

        def targets(&block)
          @targeting = block
        end

        def execution(&block)
          @execution = block
        end

        def to_definition
          Definition.new(key: key, targeting: targeting, execution: execution)
        end
      end

      class Definition
        attr_reader :key, :targeting, :execution

        def initialize(key:, targeting:, execution:)
          @key = key
          @targeting = targeting
          @execution = execution
        end

        def evaluate(context, target)
          Evaluated.new(self, context, target)
        end

        class Evaluated
          attr_reader :definition, :context, :target

          delegate :active_player, :passive_players,
            to: :context

          def initialize(definition, context, target)
            @definition = definition
            @context = context
            @target = target
          end

          def eligible?
            true
          end

          def key
            [definition.key, target.key].join(".")
          end

          def execute
            return unless definition.execution
            instance_exec(&definition.execution)
          end
        end
      end
    end
  end
end