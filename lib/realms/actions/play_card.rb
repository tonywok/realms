module Realms
  module Actions
    class PlayCard < Action
      def self.key
        :play
      end

      def execute
        active_player.play(card)
        perform active_player.in_play
      end
    end
  end
end
