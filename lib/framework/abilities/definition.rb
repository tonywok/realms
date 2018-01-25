require "realms/yielder"
require "realms/abilities/ability"
require "realms/abilities/trade"

module Framework
  module Abilities
    class Definition
      def to_ability(card, turn)
        SequenceAbility.new(self, card, turn)
      end

      def effects
        @effects ||= []
      end

      def trade(num)
        effects << EffectDefinition.new(::Realms::Abilities::Trade, num)
      end

      class EffectDefinition
        attr_reader :effect_class, :num

        def initialize(effect_class, num)
          @effect_class = effect_class
          @num = num
        end

        def to_effect(card, turn)
          effect_class[num].new(card, turn)
        end
      end

      class SequenceAbility < ::Realms::Abilities::Ability
        attr_reader :definition
        delegate :effects, to: :definition

        def initialize(definition, card, turn)
          @definition = definition
          super(card, turn)
        end

        def execute
          effects.each do |effect|
            perform effect.to_effect(card, turn)
          end
        end
      end
    end
  end
end
