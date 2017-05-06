module Realms
  module Abilities
    class Ability < Yielder
      attr_reader :card, :turn, :optional

      delegate :active_player, :trade_deck, to: :turn

      def initialize(card, turn, optional: false)
        @card = card
        @turn = turn
        @optional = optional
      end

      def self.static?
        false
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
