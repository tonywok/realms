module Realms2
  module Cards
    class BlobFighter < Card
      faction :blob
      cost 1
      primary_ability Abilities::Combat[3]
      ally_ability Abilities::Draw[1]
    end
  end
end
