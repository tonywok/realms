require "realms/turns/declarations"
require "realms/turns/phases/definition"
require "realms/turns/structure"

module Realms
  module Turns
    class Builder
      attr_reader :kind, :declarations

      def self.sequence
        new(kind: Declarations::Sequence)
      end

      def self.modal
        new(kind: Declarations::Modal)
      end

      def self.loop
        new(kind: Declarations::Loop)
      end

      def self.build(kind: Abilities::Declarations::Sequence, &block)
        builder = new(kind: kind)
        builder.instance_exec(&block)
        builder.to_definition
      end

      def initialize(kind:)
        @kind = kind
        @declarations = []
      end

      def phase(key, &execution)
        definition = Phases::Definition.new(key: key, execution: execution)
        declarations << Declarations::Phase.new(definition: definition)
      end

      def loop(key, &block)
        loop_builder = self.class.loop
        loop_builder.instance_exec(&block)
        declarations << Declarations::Loop.new(key: key, declarations: loop_builder.declarations)
      end

      def choose(&block)
        modal_builder = self.class.modal
        modal_builder.instance_exec(&block)
        declarations << Abilities::Declarations::Modal.new(:declarations => modal_builder.declarations)
      end

      def to_definition
        Structure.new(:declaration => Abilities::Declarations::Sequence.new(declarations: declarations))
      end
    end
  end
end