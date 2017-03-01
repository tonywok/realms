module Realms
  module Cards
    class FederationShuttle < Card
      faction :trade_federation
      cost 1
      primary_ability Abilities::Trade[2]
      ally_ability Abilities::Authority[4]
    end
  end
end
