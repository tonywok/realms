module Realms
  module Cards
    class ImperialFighter < Card
      faction Factions::STAR_ALLIANCE
      cost 1
      primary_ability Abilities::Combat[2]
      primary_ability Abilities::Discard[1]
      ally_ability Abilities::Combat[2]
    end
  end
end
