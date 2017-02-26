module Realms
  module Cards
    class TheHive < Card
      type :base
      faction :blob
      cost 5
      primary_ability Abilities::Combat[3]
      ally_ability Abilities::Draw[1]
    end
  end
end
