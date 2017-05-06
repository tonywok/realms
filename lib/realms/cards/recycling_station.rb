module Realms
  module Cards
    class RecyclingStation < Card
      type :outpost
      defense 4
      faction Factions::STAR_ALLIANCE
      cost 4
      primary_ability Abilities::Choose[
        Abilities::Trade[1],
        Abilities::DiscardToDraw[2]
      ], optional: true
    end
  end
end
