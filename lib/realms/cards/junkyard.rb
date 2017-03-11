module Realms
  module Cards
    class Junkyard < Card
      type :outpost
      defense 5
      faction :machine_cult
      cost 6
      primary_ability Abilities::ScrapFromHandOrDiscardPile, optional: true
    end
  end
end
