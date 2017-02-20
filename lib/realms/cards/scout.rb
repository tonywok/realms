module Realms
  module Cards
    class Scout < Card
      cost 0
      faction :unaligned
      primary_ability Abilities::Trade[1]
    end
  end
end
