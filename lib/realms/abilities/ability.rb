module Realms
  module Abilities
    class Ability < Yielder
      include Brainguy::Observer

      attr_reader :card, :turn, :optional

      delegate :active_player, :trade_deck, to: :turn

      def initialize(card, turn, optional: false)
        @card = card
        @turn = turn
        @optional = optional
      end

      def choose(options, name: self.class.key, optionality: optional, count: 1, &block)
        choice = if count == 1
                   Choice.new(options, name: name, optional: optionality)
                 else
                   MultiChoice.new(options, name: name, count: count)
                 end
        super(choice) { |decision| yield(decision) }
      end

      def may_choose(options, **kwargs, &block)
        choose(options, kwargs.merge(optionality: true), &block)
      end

      def choose_many(options, count:, **kwargs, &block)
        choose(options, kwargs.merge(count: count), &block)
      end

      def self.auto?
        false
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
