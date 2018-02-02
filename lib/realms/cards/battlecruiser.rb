module Realms
  module Cards
    class Battlecruiser < Card
      include Framework::Cards::Dsl

      faction Factions::STAR_ALLIANCE
      cost 6

      primary do
        combat 5
        draw 1
      end

      ally do
        discard 1
      end

      scrap do
        draw 1
        destroy_target_base optional: true
      end
    end
  end
end
