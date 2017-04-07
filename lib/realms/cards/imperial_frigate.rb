module Realms
  module Cards
    class ImperialFrigate < Card
      faction :star_empire
      cost 3
      primary_ability Abilities::Combat[4]
      primary_ability Abilities::Discard[1]
      ally_ability Abilities::Combat[2]
      scrap_ability Abilities::Draw[1]
    end
  end
end
