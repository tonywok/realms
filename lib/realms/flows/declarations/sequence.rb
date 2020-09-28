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

          def initialize(declaration, context)
            @declaration = declaration
            @context = context
          end

          def execute
            declaration.declarations.each do |declaration|
              begin
              effect = declaration.evaluate(context) 
              context.perform(effect)
              rescue => e
                binding.pry
              end
            end
          end
        end
      end
    end
  end
end