module Realms
  module Cards
    class FleetHQ < Card
      faction Factions::STAR_ALLIANCE
      type :base
      defense 8
      cost 8

      primary do
        # on(type: :ship) do |ship|
        #   combat 1
        # end
        # all_ships_get_combat
      end
    end
  end
end
