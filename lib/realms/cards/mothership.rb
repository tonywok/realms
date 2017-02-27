module Realms
  module Cards
    class Mothership < Card
      faction :blob
      cost 7
      primary_ability Abilities::Combat[6]
      primary_ability Abilities::Draw[1]
      ally_ability Abilities::Draw[1]
    end
  end
end
