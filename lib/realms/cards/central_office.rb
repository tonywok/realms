module Realms
  module Cards
    class CentralOffice < Card
      type :base
      defense 6
      faction :trade_federation
      cost 7
      primary_ability Abilities::Trade[2]
      primary_ability Abilities::TopDeckNextShip, optional: true
      ally_ability Abilities::Draw[1]
    end
  end
end
