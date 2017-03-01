module Realms
  module Abilities
    class TopDeckNextShip < Ability
      def execute
      end
    end
  end

  module Cards
    class Freighter < Card
      faction :trade_federation
      cost 4
      primary_ability Abilities::Trade[4]
      ally_ability Abilities::TopDeckNextShip
    end
  end
end
