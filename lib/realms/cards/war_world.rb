module Realms
  module Cards
    class WarWorld < Card
      type :outpost
      defense 4
      faction Factions::STAR_ALLIANCE
      cost 5

      primary do
        combat 3
      end

      ally do
        combat 4
      end
    end
  end
end
