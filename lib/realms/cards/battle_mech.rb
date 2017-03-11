module Realms
  module Cards
    class BattleMech < Card
      faction :machine_cult
      cost 5
      primary_ability Abilities::Combat[4]
      primary_ability Abilities::ScrapFromHandOrDiscardPile, optional: true
      ally_ability Abilities::Draw[1]
    end
  end
end
