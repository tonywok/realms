module Realms
  module Abilities
    class Trade < Ability
      def self.key
        :trade
      end

      def self.auto?
        true
      end

      def execute
        turn.trade += arg
      end
    end
  end
end
