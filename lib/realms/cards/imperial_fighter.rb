module Realms
  module Cards
    class ImperialFighter < Card
      include Framework::Cards::Dsl

      faction Factions::STAR_ALLIANCE
      cost 1

      primary do
        combat 2
        discard 1
      end

      ally do
        combat 2
      end
    end
  end
end
