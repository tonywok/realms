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

      # TODO: move realms specific stuff out of framework
      def trade(num)
        effects << Effects::Definition.new(::Realms::Abilities::Trade, num)
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
