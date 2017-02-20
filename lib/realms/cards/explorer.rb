module Realms
  module Cards
    class Explorer < Card
      cost 2
      faction :unaligned
      primary_ability Abilities::Trade[2]
      scrap_ability Abilities::Combat[2]
    end
  end
end
