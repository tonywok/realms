module Realms
  module Cards
    class BattleBlob < Card
      faction :blob
      cost 6
      primary_ability Abilities::Combat[8]
      ally_ability Abilities::Draw[1]
      scrap_ability Abilities::Combat[4]
    end
  end
end
