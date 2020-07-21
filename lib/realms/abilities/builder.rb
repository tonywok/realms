require "realms/abilities/declarations/effect"

module Realms
  module Abilities
    class Builder
      include Flows::Builder

      Effects.registry.registrations.each do |effect_key, effect_definition|
        define_method(effect_key) do |amount = nil, optional: false|
          declarations << Declarations::Effect.new(definition: effect_definition, amount: amount, optional: optional)
        end
      end

      def to_definition
        Abilities::Definition.new(:declaration => Flows::Declarations::Sequence.new(declarations: declarations))
      end
    end
  end
end