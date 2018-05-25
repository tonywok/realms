module Realms
  module Effects
    class Combat < Numeric
      def execute
        turn.combat += num
      end

      def notify
        publish(:combat)
      end

      def self.auto?
        true
      end
    end
  end
end
