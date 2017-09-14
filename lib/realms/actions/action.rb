require "active_support/string_inquirer"

module Realms
  module Actions
    class Action < Yielder
      attr_reader :turn, :target

      delegate :active_player, :passive_player,
        to: :turn

      def initialize(turn, target = nil)
        @turn = turn
        @target = target
      end

      def card
        target
      end

      def key
        [self.class.key, target&.key].compact.join(".")
      end

      def auto?
        false
      end

      def choose(options, subject: key, **kwargs)
        super
      end

      def execute
      end
    end
  end
end
