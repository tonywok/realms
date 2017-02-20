module Realms2
  module Cards
    class BlobWheel < Base
      faction :blob
      cost 3
      primary_ability Abilities::Combat[1]
      scrap_ability Abilities::Trade[3]
    end
  end
end
