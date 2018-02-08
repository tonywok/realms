module Realms
  module Cards
    class SurveyShip < Card
      include Framework::Cards::Dsl

      faction Factions::STAR_ALLIANCE
      cost 3

      primary do
        trade 1
        draw 1
      end

      scrap do
        discard 1
      end
    end
  end
end
