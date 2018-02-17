module Realms
  module Cards
    class MachineBase < Card
      type :outpost
      defense 6
      faction :machine_cult
      cost 7

      primary do
        effect(:draw_then_scrap_from_hand) do

        end
      end
    end
  end
end
