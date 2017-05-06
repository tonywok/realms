module Realms
  module Cards
    class Dreadnaught < Card
      faction Factions::STAR_ALLIANCE
      cost 7
      primary_ability Abilities::Combat[7]
      primary_ability Abilities::Draw[1]
      scrap_ability Abilities::Combat[5]
    end
  end
end
