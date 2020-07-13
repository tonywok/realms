module Realms
  module Abilities
    module Declarations
      class Modal
        attr_reader :declarations

        def initialize(declarations:)
          @declarations = declarations
        end

        def evaluate(context)
          Evaluated.new(self, context)
        end

        delegate :game, to: :context

        def auto?
          false
        end

        class Evaluated
          attr_reader :declaration, :context

          delegate :game, to: :context
          delegate :choose, to: :game
          delegate :active_turn, :active_player, :passive_player, to: :game

          def initialize(declaration, context)
            @declaration = declaration
            @context = context
          end

          def execute
            choose(declaration.declarations, subject: context.card.name) do |declaration|
              effect = declaration.evaluate(context) 
              game.perform(effect)
            end
          end
        end
      end
    end
  end
end