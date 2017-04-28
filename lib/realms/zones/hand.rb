module Realms
  module Zones
    class Hand < Zone
      def actions(turn)
        cards.map { |card| Actions::PlayCard.new(turn, card) }
      end
    end
  end
end
