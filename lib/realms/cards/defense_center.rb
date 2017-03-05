module Realms
  module Cards
    class DefenseCenter < Card
      type :outpost
      faction :trade_federation
      cost 5
      primary_ability Abilities::Choose[
        Abilities::Authority[3],
        Abilities::Combat[2],
      ]
      ally_ability Abilities::Combat[2]
    end
  end
end
