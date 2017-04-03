module Realms
  module Cards
    class ImperialFighter < Card
      faction :star_empire
      cost 1
      primary_ability Abilities::Combat[2]
      primary_ability Abilities::Discard[1]
      ally_ability Abilities::Combat[2]
    end
  end
end
