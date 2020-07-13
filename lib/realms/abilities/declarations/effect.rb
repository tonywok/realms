module Realms
  module Abilities
    module Declarations
      class Effect
        attr_reader :definition, :amount, :optional

        delegate :auto?, :key,
          to: :definition

        def initialize(definition:, amount:, optional: false)
          @definition = definition
          @amount = amount
          @optional = optional
        end

        def evaluate(context)
          Evaluated.new(declaration: self, context: context)
        end

        class Evaluated
          include Brainguy::Observable

          attr_reader :context, :declaration, :listeners

          # TODO: access to all zone methods via registry
          delegate :game, :card, to: :context
          delegate :perform, :active_turn, :active_player, :passive_player, :trade_deck, to: :game
          delegate :trade_row, to: :trade_deck
          delegate :in_play, to: :active_player

          delegate :definition, :optional, to: :declaration
          delegate :auto?, :key, to: :definition

          def initialize(context:, declaration:)
            @context = context
            @declaration = declaration
          end

          def choose(options, **kwargs, &block)
            game.choose(options, optionality: declaration.optional, subject: declaration.key, **kwargs, &block)
          end

          def may_choose_many(options, **kwargs, &block)
            game.may_choose_many(options, subject: declaration.key, **kwargs, &block)
          end

          def execute
            instance_exec(declaration.amount, &declaration.definition.execution)
            game.publish(key)
          end
        end
      end
    end
  end
end