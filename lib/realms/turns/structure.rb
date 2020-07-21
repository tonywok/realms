module Realms
  module Turns
    class Structure
      attr_reader :declaration

      def initialize(declaration:)
        @declaration = declaration
      end

      def evaluate(context)
        Evaluated.new(declaration, context)
      end

      class Evaluated
        attr_reader :declaration, :context

        def initialize(declaration, context)
          @declaration = declaration
          @context = context
        end

        def once(phase, player:, &handler)
          event = [player.key, phase].join(":").to_sym
          sub = context.on(event) do
            handler.call
            sub.cancel
          end
        end

        def execute
          declaration.evaluate(context).execute
        end
      end
    end
  end
end