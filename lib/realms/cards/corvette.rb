module Realms
  module Cards
    class Corvette < Card
      faction :star_empire
      cost 2
      primary_ability Abilities::Combat[1]
      primary_ability Abilities::Draw[1]
      ally_ability Abilities::Combat[2]
    end
  end
end
