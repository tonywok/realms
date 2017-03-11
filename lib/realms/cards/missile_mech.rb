module Realms
  module Cards
    class MissileMech < Card
      faction :machine_cult
      cost 6
      primary_ability Abilities::Combat[6]
      primary_ability Abilities::DestroyTargetBase, optional: true
      ally_ability Abilities::Draw[1]
    end
  end
end
