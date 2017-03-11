module Realms
  module Cards
    class MechWorld < Card
      type :outpost
      defense 6
      faction :machine_cult
      cost 5

      def ally_factions
        Factions::ALL
      end
    end
  end
end
