module Realms
  module Cards
    class BattleStation < Card
      include Framework::Cards::Dsl

      type :outpost
      defense 5
      faction :machine_cult
      cost 3

      scrap do
        combat 5
      end
    end
  end
end
