module Realms
  module Cards
    class BattleStation < Card
      type :outpost
      defense 5
      faction :machine_cult
      cost 3
      scrap_ability Abilities::Combat[5]
    end
  end
end
