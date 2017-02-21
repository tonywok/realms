module Realms
  module Cards
    class TradePod < Card
      faction :blob
      cost 2
      primary_ability Abilities::Trade[3]
      ally_ability Abilities::Combat[2]
    end
  end
end
