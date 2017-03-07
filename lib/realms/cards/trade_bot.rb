module Realms
  module Cards
    class TradeBot < Card
      faction :machine_cult
      cost 1
      primary_ability Abilities::Trade[1]
      primary_ability Abilities::ScrapFromHandOrDiscardPile[1], optional: true
      ally_ability Abilities::Combat[2]
    end
  end
end
