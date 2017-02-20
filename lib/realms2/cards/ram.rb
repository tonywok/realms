module Realms2
  module Cards
    class Ram < Card
      faction :blob
      cost 3
      primary_ability Abilities::Combat[5]
      ally_ability Abilities::Combat[2]
      scrap_ability Abilities::Trade[3]
    end
  end
end
