module Realms
  module Cards
    class BlobCarrier < Card
      faction :blob
      cost 6
      primary_ability Abilities::Combat[7]
      ally_ability Abilities::AcquireShipAndTopDeck[1], optional: true
    end
  end
end
