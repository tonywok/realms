module Realms
  module Phases
    class Discard < Phase
      def execute
        turn.trade = 0
        turn.combat = 0
        deck.in_play.select(&:ship?).each { |ship| deck.destroy(ship) }
        deck.in_play.cards_in_play.select(&:base?).each { |base| base.reset! }
        deck.discard_hand
      end

      def deck
        @deck ||= turn.active_player.deck
      end
    end
  end
end
