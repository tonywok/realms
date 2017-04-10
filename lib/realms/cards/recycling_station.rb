module Realms
  module Cards
    class RecyclingStation < Card
      type :outpost
      defense 4
      faction :star_empire
      cost 4
      primary_ability Abilities::Choose[
        Abilities::Trade[1],
        Abilities::DiscardToDraw[2]
      ], optional: true
    end
  end
end
