module Realms
  module Cards
    class SupplyBot < Card
      faction :machine_cult
      cost 3
      primary_ability Abilities::Trade[2]
      primary_ability Abilities::ScrapFromHandOrDiscardPile, optional: true
      ally_ability Abilities::Combat[2]
    end
  end
end
