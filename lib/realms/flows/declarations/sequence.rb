module Realms
  module Flows
    module Declarations
      class Sequence
        attr_reader :declarations

        def initialize(declarations:)
          @declarations = declarations
        end

        def evaluate(context)
          Evaluated.new(self, context)
        end

        def auto?
          declarations.all?(&:auto?)
        end

        class Evaluated
          attr_reader :declaration, :context

          delegate :game, to: :context

          def initialize(declaration, context)
            @declaration = declaration
            @context = context
          end

          def execute
            declaration.declarations.each do |declaration|
              effect = declaration.evaluate(context) 
              game.perform(effect)
            end
          end
        end
      end
    end
  end
end