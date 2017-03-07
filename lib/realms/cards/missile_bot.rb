module Realms
  module Cards
    class MissileBot < Card
      faction :machine_cult
      cost 2
      primary_ability Abilities::Combat[2]
      primary_ability Abilities::ScrapFromHandOrDiscardPile[1], optional: true
      ally_ability Abilities::Combat[2]
    end
  end
end
