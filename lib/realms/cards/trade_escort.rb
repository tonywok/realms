module Realms
  module Cards
    class TradeEscort < Card
      faction :trade_federation
      cost 5
      primary_ability Abilities::Authority[4]
      primary_ability Abilities::Combat[4]
      ally_ability Abilities::Draw[1]
    end
  end
end
