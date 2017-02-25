module Realms
  module Cards
    class BlobDestroyer < Card
      faction :blob
      cost 4
      primary_ability Abilities::Combat[6]
      ally_ability Abilities::DestroyTargetBase, optional: true
      ally_ability Abilities::ScrapCardFromTradeRow, optional: true
    end
  end
end
