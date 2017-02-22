module Realms
  module Cards
    class BattlePod < Card
      faction :blob
      cost 2
      primary_ability Abilities::Combat[4]
      primary_ability Abilities::ScrapCardFromTradeRow[1]
      ally_ability Abilities::Combat[2]
    end
  end
end
