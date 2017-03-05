module Realms
  module Cards
    class TradingPost < Card
      type :outpost
      defense 4
      faction :trade_federation
      cost 3
      primary_ability Abilities::Choose[
        Abilities::Authority[1],
        Abilities::Trade[1],
      ]
      scrap_ability Abilities::Combat[3]
    end
  end
end
