module Realms
  module Cards
    class WarWorld < Card
      type :outpost
      defense 4
      faction Factions::STAR_ALLIANCE
      cost 5
      primary_ability Abilities::Combat[3]
      ally_ability Abilities::Combat[4]
    end
  end
end
