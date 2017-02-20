module Realms2
  module Cards
    class TradePod < Card
      cost 2
      faction :blob
      primary_ability Abilities::Trade[3]
      ally_ability Abilities::Combat[2]
    end
  end
end
