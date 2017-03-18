module Realms
  module Abilities
    class TopDeckNextShip < Ability
      def self.key
        :top_deck_next_ship
      end

      def execute
        Actions::AcquireCard.subscribe(self)
      end

      def card_acquired(acquire_card)
        acquire_card.zone = :draw_pile
        Wisper.unsubscribe(self)
      end
    end
  end
end
