module Realms
  module Cards
    class BlobWheel < Card
      type :base
      defense 5
      faction :blob
      cost 3
      primary_ability Abilities::Combat[1]
      scrap_ability Abilities::Trade[3]
    end
  end
end
