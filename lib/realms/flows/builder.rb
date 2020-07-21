require "realms/flows/declarations"

module Realms
  module Flows
    module Builder
      extend ActiveSupport::Concern

      class_methods do
        def sequence
          new(kind: Declarations::Sequence)
        end

        def modal
          new(kind: Declarations::Modal)
        end

        def loop
          new(kind: Declarations::Loop)
        end

        def build(kind: Declarations::Sequence, &block)
          builder = new(kind: kind)
          builder.instance_exec(&block)
          builder.to_definition
        end
      end

      attr_reader :kind, :declarations

      def initialize(kind:)
        @kind = kind
        @declarations = []
      end

      def choose(&block)
        modal_builder = self.class.modal
        modal_builder.instance_exec(&block)
        declarations << Declarations::Modal.new(:declarations => modal_builder.declarations)
      end

      def loop(key, &block)
        loop_builder = self.class.loop
        loop_builder.instance_exec(&block)
        declarations << Declarations::Loop.new(key: key, declarations: loop_builder.declarations)
      end

      def to_definition
        raise NotImplemented
      end
    end
  end
end