require_relative "ability_definition"
require_relative "effect_registry"

module Realms
  module Refactor
    class AbilityBuilder
      attr_reader :effect_declarations

      def initialize
        @effect_declarations = []
      end

      def self.effect_registry
        @effect_registry ||= EffectRegistry.configure do
          effect(:trade, auto: true) do |amount|
            active_turn.trade += amount
          end

          effect(:combat, auto: true) do |amount|
            active_turn.combat += amount
          end

          effect(:authority) do |amount|
            active_player.authority += amount
          end
        end
      end

      effect_registry.registrations.each do |effect_key, effect_definition|
        define_method(effect_key) do |amount|
          effect_declarations << effect_definition.to_declaration(amount: amount)
        end
      end

      def to_definition
        AbilityDefinition.new(
          :effect_declarations => effect_declarations
        )
      end
    end
  end
end