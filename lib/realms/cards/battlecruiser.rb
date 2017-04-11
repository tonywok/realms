module Realms
  module Cards
    class Battlecruiser < Card
      faction :star_empire
      cost 6
      primary_ability Abilities::Combat[5]
      primary_ability Abilities::Draw[1]
      ally_ability Abilities::Discard[1]
      scrap_ability Abilities::Draw[1]
      scrap_ability Abilities::DestroyTargetBase, optional: true
    end
  end
end
