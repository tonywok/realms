module Realms
  module Cards
    class Flagship < Card
      faction :trade_federation
      cost 6
      primary_ability Abilities::Combat[5]
      primary_ability Abilities::Draw[1]
      ally_ability Abilities::Authority[5]
    end
  end
end
