module Realms
  module Cards
    class SurveyShip < Card
      faction :star_empire
      cost 3
      primary_ability Abilities::Trade[1]
      primary_ability Abilities::Draw[1]
      scrap_ability Abilities::Discard[1]
    end
  end
end
