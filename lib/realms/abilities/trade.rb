module Realms
  module Abilities
    class Trade < Ability
      def execute
        turn.trade += arg
      end
    end
  end
end
