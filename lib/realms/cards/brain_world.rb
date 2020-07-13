module Realms
  module Cards
    class BrainWorld < Card
      type :outpost
      defense 6
      faction :machine_cult
      cost 8

      primary do
        draw_for_each_scrap_from_hand_or_discard_pile 2
      end
    end
  end
end
