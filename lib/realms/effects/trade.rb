module Realms
  module Effects
    class Trade < Numeric
      def execute
        turn.trade += num
      end

      def notify
        publish(:trade)
      end

      def self.auto?
        true
      end
    end
  end
end
