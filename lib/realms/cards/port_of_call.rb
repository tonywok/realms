module Realms
  module Cards
    class PortOfCall < Card
      type :outpost
      defense 6
      faction :trade_federation
      cost 6
      primary_ability Abilities::Trade[3]
      scrap_ability Abilities::Draw[1]
      scrap_ability Abilities::DestroyTargetBase, optional: true
    end
  end
end
