module Realms
  module Cards
    class Explorer < Card
      faction :unaligned
      cost 2
      primary_ability Abilities::Trade[2]
      scrap_ability Abilities::Combat[2]
    end
  end
end
