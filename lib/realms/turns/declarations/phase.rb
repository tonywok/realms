module Realms
  module Turns
    module Declarations
      class Phase
        attr_reader :definition

        def initialize(definition:)
          @definition = definition
        end

        def evaluate(context)
          Evaluated.new(self, context)
        end

        class Evaluated
          attr_reader :declaration, :context

          delegate :game, :card, to: :context
          delegate :choose, :perform, :active_turn, :active_player, :passive_player, :trade_deck, to: :game
          delegate :trade_row, to: :trade_deck
          delegate :in_play, to: :active_player

          def initialize(declaration, context)
            @declaration = declaration
            @context = context
          end

          def execute
            event = [active_player.key, declaration.definition.key].join(":")
            beginning = [event, :beginning].join(":").to_sym
            ending = [event, :ending].join(":").to_sym

            context.emit(beginning)
            instance_exec(&declaration.definition.execution) if declaration.definition.execution
            context.emit(ending)
          end
        end
      end
    end
  end
end