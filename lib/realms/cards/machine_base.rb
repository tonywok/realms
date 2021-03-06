module Realms
  module Cards
    class MachineBase < Card
      type :outpost
      defense 6
      faction :machine_cult
      cost 7

      primary do
        draw_then_scrap_from_hand 1
      end
    end
  end
end
