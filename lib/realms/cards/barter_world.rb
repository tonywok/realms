module Realms
  module Cards
    class BarterWorld < Card
      type :base
      faction :trade_federation
      cost 4
      primary_ability Abilities::Choose[
        Abilities::Authority[2],
        Abilities::Trade[2],
      ]
      scrap_ability Abilities::Combat[5]
    end
  end
end
