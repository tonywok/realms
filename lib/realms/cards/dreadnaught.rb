module Realms
  module Cards
    class Dreadnaught < Card
      faction Factions::STAR_ALLIANCE
      cost 7

      primary do
        combat 7
        draw 1
      end

      scrap do
        combat 5
      end
    end
  end
end
