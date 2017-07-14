module Realms
  module Abilities
    class DrawForEachScrapFromHandOrDiscardPile < Ability
      def self.key
        :draw_for_each_scrap_from_hand_or_discard_pile # lol
      end

      def execute
        choose(MultiChoice.new(zones.flat_map(&:cards), count: arg)) do |cards|
          cards.each do |selected_card|
            turn.trade_deck.scrap(selected_card)
          end
          cards.length.times { active_player.draw_pile.transfer!(to: active_player.hand) }
        end
      end

      def zones
        [active_player.hand, active_player.discard_pile]
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
