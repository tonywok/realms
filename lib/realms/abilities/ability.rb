module Realms
  module Abilities
    class Ability < Yielder
      attr_reader :turn, :optional

      def initialize(turn, optional: false)
        @turn = turn
        @optional = optional
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
