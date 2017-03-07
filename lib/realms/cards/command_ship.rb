module Realms
  module Cards
    class CommandShip < Card
      faction :trade_federation
      cost 8
      primary_ability Abilities::Authority[4]
      primary_ability Abilities::Combat[5]
      primary_ability Abilities::Draw[2]
      ally_ability Abilities::DestroyTargetBase
    end
  end
end
