module Realms
  module Cards
    class Freighter < Card
      faction :trade_federation
      cost 4
      primary_ability Abilities::Trade[4]
      ally_ability Abilities::TopDeckNextShip
    end
  end
end
