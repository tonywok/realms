module Realms
  module Phases
    class Discard < Phase
      def execute
        turn.trade = 0
        turn.combat = 0
        active_player.in_play.select(&:ship?).each do |ship|
          active_player.destroy(ship)
        end
        active_player.discard_hand
      end
    end
  end
end
