module Realms
  module Cards
    class ImperialFrigate < Card
      include Framework::Cards::Dsl

      faction Factions::STAR_ALLIANCE
      cost 3

      primary do
        combat 4
        discard 1
      end

      ally do
        combat 2
      end

      scrap do
        draw 1
      end
    end
  end
end
