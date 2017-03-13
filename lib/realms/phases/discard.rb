module Realms
  module Phases
    class Discard < Phase
      def execute
        turn.trade = 0
        turn.combat = 0
        deck.battlefield.select(&:ship?).each { |ship| deck.destroy(ship) }
        deck.discard_hand
      end

      def deck
        @deck ||= turn.active_player.deck
      end
    end
  end
end
