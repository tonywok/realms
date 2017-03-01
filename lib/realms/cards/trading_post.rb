module Realms
  module Cards
    class TradingPost < Card
      type :base
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
