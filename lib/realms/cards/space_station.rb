module Realms
  module Cards
    class SpaceStation < Card
      include Framework::Cards::Dsl

      type :outpost
      defense 4
      faction Factions::STAR_ALLIANCE
      cost 4

      primary do
        combat 2
      end

      ally do
        combat 2
      end

      scrap do
        trade 4
      end
    end
  end
end
