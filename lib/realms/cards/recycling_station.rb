module Realms
  module Cards
    class RecyclingStation < Card
      include Framework::Cards::Dsl

      type :outpost
      defense 4
      faction Factions::STAR_ALLIANCE
      cost 4

      primary do
        choose do
          trade 1
          discard_to_draw 2
        end
      end
    end
  end
end
