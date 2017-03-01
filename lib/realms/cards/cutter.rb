module Realms
  module Cards
    class Cutter < Card
      faction :trade_federation
      cost 2
      primary_ability Abilities::Authority[4]
      primary_ability Abilities::Trade[2]
      ally_ability Abilities::Combat[4]
    end
  end
end
