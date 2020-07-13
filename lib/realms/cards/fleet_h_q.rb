module Realms
  module Cards
    class FleetHQ < Card
      faction Factions::STAR_ALLIANCE
      type :base
      defense 8
      cost 8

      primary do
        all_ships_get_combat
      end
    end
  end
end
