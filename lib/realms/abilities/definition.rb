module Realms
  module Abilities
    class Definition
      attr_reader :declaration

      def initialize(declaration:)
        @declaration = declaration
      end

      def evaluate(context)
        declaration.evaluate(context)
      end

      def auto?
        declaration.auto?
      end
    end
  end
end