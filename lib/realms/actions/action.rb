require "active_support/string_inquirer"

module Realms
  module Actions
    class Action < Yielder
      attr_reader :turn

      delegate :active_player, :passive_player,
        to: :turn

      def initialize(turn)
        @turn = turn
      end

      def key
        ActiveSupport::StringInquirer.new(self.class.key.to_s)
      end

      def execute
      end
    end
  end
end
