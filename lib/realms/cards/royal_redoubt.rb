module Realms
  module Cards
    class RoyalRedoubt < Card
      type :outpost
      defense 6
      faction :star_empire
      cost 6
      primary_ability Abilities::Combat[3]
      ally_ability Abilities::Discard[1]
    end
  end
end
