module Realms
  module Cards
    class SpaceStation < Card
      type :outpost
      defense 4
      faction :star_empire
      cost 4
      primary_ability Abilities::Combat[2]
      ally_ability Abilities::Combat[2]
      scrap_ability Abilities::Trade[4]
    end
  end
end
