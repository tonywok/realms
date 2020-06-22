module Realms
  module Refactor
    class AbilityDefinition
      attr_reader :effect_declarations

      def initialize(effect_declarations:)
        @effect_declarations = effect_declarations
      end

      def to_effect(context)
        SequenceEffect.new(definition: self, context: context)
      end

      class SequenceEffect
        attr_reader :definition, :context

        delegate :game, to: :context

        def initialize(definition:, context:)
          @definition = definition
          @context = context
        end

        def __execute
          definition.effect_declarations.each do |effect_declarations|
            effect = effect_declarations.to_effect(context) 
            game.perform(effect)
          end
        end
      end
    end
  end
end