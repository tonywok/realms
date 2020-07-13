require "realms/abilities/declarations"

module Realms
  module Abilities
    class Builder
      attr_reader :kind, :declarations

      def self.sequence
        new(kind: Declarations::Sequence)
      end

      def self.modal
        new(kind: Declarations::Modal)
      end

      def self.build(kind: Declarations::Sequence, &block)
        builder = new(kind: kind)
        builder.instance_exec(&block)
        builder.to_definition
      end

      def initialize(kind:)
        @kind = kind
        @declarations = []
      end

      Effects.registry.registrations.each do |effect_key, effect_definition|
        define_method(effect_key) do |amount = nil, optional: false|
          declarations << Declarations::Effect.new(definition: effect_definition, amount: amount, optional: optional)
        end
      end

      def choose(&block)
        modal_builder = self.class.modal
        modal_builder.instance_exec(&block)
        declarations << Declarations::Modal.new(:declarations => modal_builder.declarations)
      end

      def to_definition
        Abilities::Definition.new(:declaration => Declarations::Sequence.new(declarations: declarations))
      end
    end
  end
end