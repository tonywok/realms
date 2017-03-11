module Realms
  module Cards
    class MachineBase < Card
      type :outpost
      defense 6
      faction :machine_cult
      cost 7
      primary_ability Abilities::DrawThenScrapFromHand
    end
  end
end
