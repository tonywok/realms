module Realms
  module Abilities
    class DrawForEachScrapFromHandOrDiscardPile < Ability
      def self.key
        :draw_for_each_scrap_from_hand_or_discard_pile # lol
      end

      def execute
        cards_scraped = arg.times.map.select do
          choose(Choice.new(cards_in_hand_or_discard_pile, optional: optional)) do |card|
            turn.trade_deck.scrap_heap << turn.active_player.deck.scrap(card)
            card
          end
        end
        active_player.draw(cards_scraped.length)
      end

      def cards_in_hand_or_discard_pile
        turn.active_player.deck.hand + turn.active_player.deck.discard_pile
      end
    end
  end

  module Cards
    class BrainWorld < Card
      type :outpost
      defense 6
      faction :machine_cult
      cost 8
      primary_ability Abilities::DrawForEachScrapFromHandOrDiscardPile[2], optional: true
    end
  end
end
