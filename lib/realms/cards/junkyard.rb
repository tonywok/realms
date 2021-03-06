module Realms
  module Cards
    class Junkyard < Card
      type :outpost
      defense 5
      faction :machine_cult
      cost 6

      primary do
        scrap_from_hand_or_discard_pile optional: true
      end
    end
  end
end
