module Realms
  module Actions
    class Action
      attr_reader :turn, :target

      delegate :active_player, :passive_player,
        to: :turn

      include Yielder::Gutted

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

      def choose(options, subject: key, **kwargs, &block)
        game.choose(options, subject: subject, **kwargs, &block)
      end

      def execute
      end
    end
  end
end
