module Realms
  module Refactor
    class AbilityDefinition
      attr_reader :kind, :declarations

      def initialize(declaration)
        @declarations = declarations
      end

      def evaluate(context)
        kind.new(definition: self, context: context)
      end

      def auto?
        declarations.all?(&:auto?)
      end
    end
  end
end