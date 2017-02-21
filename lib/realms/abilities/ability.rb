module Realms
  module Abilities
    class Ability < Yielder
      attr_reader :turn

      def initialize(turn)
        @turn = turn
      end

      class_attribute :arg, instance_predicate: false, instance_writer: false

      def self.[](arg)
        @klass_cache ||= {}
        @klass_cache[arg] ||= Class.new(self) do |new_class|
          new_class.arg = arg
        end
      end
    end
  end
end
