module Realms
  module Cards
    class RecyclingStation < Card
      type :outpost
      defense 4
      faction Factions::STAR_ALLIANCE
      cost 4

      primary do
        choose do
          trade 1
          effect(:discard_to_draw) do
            may_choose_many(active_player.hand, count: 2) do |cards|
              cards.each { |card| active_player.discard(card) }
              active_player.draw(cards.length)
            end
          end
        end
      end
    end
  end
end
