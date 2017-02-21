module Realms
  module Cards
    class Scout < Card
      faction :unaligned
      cost 0
      primary_ability Abilities::Trade[1]
    end
  end
end
