module Realms
  module Effects
    class Authority < Numeric
      def execute
        turn.active_player.authority += num
      end

      def self.auto?
        true
      end
    end
  end
end
