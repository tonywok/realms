module Realms2
  module Actions
    class CardFromHand < Choice
      def initialize(hand)
        @options = hand.each_with_object({}) do |card, cards|
          cards[card.name.downcase.to_sym] = card
        end
      end
    end

    class PlayCard < Action
      def execute
        choose CardFromHand.new(turn.active_player.deck.hand)
      end
    end
  end
end
