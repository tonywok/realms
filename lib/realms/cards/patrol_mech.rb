module Realms
  module Cards
    class PatrolMech < Card
      faction :machine_cult
      cost 4
      primary_ability Abilities::Choose[
        Abilities::Trade[3],
        Abilities::Combat[5]
      ]
      ally_ability Abilities::ScrapFromHandOrDiscardPile[1], optional: true
    end
  end
end
