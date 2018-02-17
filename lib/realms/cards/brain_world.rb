module Realms
  module Cards
    class BrainWorld < Card
      type :outpost
      defense 6
      faction :machine_cult
      cost 8

      primary do
        effect(:draw_for_each_scrap_from_hand_or_discard_pile) do
          cards_in_hand_or_discard_pile = [active_player.hand, active_player.discard_pile].flat_map(&:cards)

          may_choose_many(cards_in_hand_or_discard_pile, count: 2) do |cards|
            cards.each { |selected_card| turn.trade_deck.scrap(selected_card) }
            active_player.draw(cards.length)
          end
        end
      end
    end
  end
end
