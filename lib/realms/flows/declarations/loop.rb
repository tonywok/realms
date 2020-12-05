module Realms
  module Flows
    module Declarations
      class Loop
        attr_reader :key, :declarations

        def initialize(key:, declarations:)
          @key = key
          @declarations = declarations
        end

        def evaluate(context)
          Evaluated.new(self, context)
        end

        class Evaluated
          attr_reader :declaration, :context

          delegate :game, to: :context

          def initialize(declaration, context)
            @declaration = declaration
            @context = context
          end

          def execute
            declaration.declarations.cycle do |declaration|
              phase = declaration.evaluate(context) 
              game.perform(phase)
            end
          end
        end
      end
    end
  end
end