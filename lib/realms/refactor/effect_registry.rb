module Realms
  module Refactor
    class EffectRegistry
      attr_reader :registrations

      def self.configure(&block)
        registry = new
        registry.instance_exec(&block)
        registry
      end

      def initialize
        @registrations = {}
      end

      def effect(key, **kwargs, &block)
        @registrations.merge!(key => EffectDefinition.new(key: key, **kwargs, &block)) do |_|
          raise("#{key} is already registered")
        end
      end

      class EffectDefinition
        attr_reader :key, :execution, :auto

        def initialize(key:, auto: false, &block)
          @key = key
          @auto = auto
          @execution = block
        end

        def to_declaration(**kwargs)
          EffectDeclaration.new(definition: self, **kwargs)
        end

        def auto?
          !!auto
        end
      end

      class EffectDeclaration
        attr_reader :definition, :amount

        def initialize(definition:, amount:)
          @definition = definition
          @amount = amount
        end

        def to_effect(context)
          Effect.new(declaration: self, context: context)
        end
      end

      class Effect
        attr_reader :context, :declaration

        delegate :game, to: :context
        delegate :active_turn, :active_player, to: :game
        delegate :authority, to: :active_player

        delegate :definition, to: :declaration
        delegate :auto?, to: :definition

        def initialize(context:, declaration:)
          @context = context
          @declaration = declaration
        end

        def __execute
          context.instance_exec(declaration.amount, &declaration.definition.execution)
        end
      end
    end
  end
end