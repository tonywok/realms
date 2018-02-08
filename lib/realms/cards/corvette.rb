module Realms
  module Cards
    class Corvette < Card
      include Framework::Cards::Dsl

      faction Factions::STAR_ALLIANCE
      cost 2

      primary do
        combat 1
        draw 1
      end

      ally do
        combat 2
      end
    end
  end
end
