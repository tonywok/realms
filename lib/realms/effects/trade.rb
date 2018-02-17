module Realms
  module Effects
    class Trade < Numeric
      def execute
        turn.trade += num
      end

      def self.auto?
        true
      end
    end
  end
end
