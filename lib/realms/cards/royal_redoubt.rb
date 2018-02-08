module Realms
  module Cards
    class RoyalRedoubt < Card
      include Framework::Cards::Dsl

      type :outpost
      defense 6
      faction Factions::STAR_ALLIANCE
      cost 6

      primary do
        combat 3
      end

      ally do
        discard 1
      end
    end
  end
end
