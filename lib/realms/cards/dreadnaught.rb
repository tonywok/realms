module Realms
  module Cards
    class Dreadnaught < Card
      faction :star_empire
      cost 7
      primary_ability Abilities::Combat[7]
      primary_ability Abilities::Draw[1]
      scrap_ability Abilities::Combat[5]
    end
  end
end
