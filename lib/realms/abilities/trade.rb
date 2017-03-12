module Realms
  module Abilities
    class Trade < Ability
      def self.key
        :trade
      end

      def execute
        turn.trade += arg
      end
    end
  end
end
