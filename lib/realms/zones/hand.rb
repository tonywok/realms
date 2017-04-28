module Realms
  module Zones
    class Hand < Zone
      def actions
        cards.map { |card| Actions::PlayCard.new(active_turn, card) }
      end
    end
  end
end
