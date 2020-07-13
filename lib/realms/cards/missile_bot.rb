module Realms
  module Cards
    class MissileBot < Card
      faction :machine_cult
      cost 2

      primary do
        combat 2
        scrap_from_hand_or_discard_pile optional: true
      end

      ally do
        combat 2
      end
    end
  end
end
