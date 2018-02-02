module Realms
  module Cards
    class BattleMech < Card
      include Framework::Cards::Dsl

      faction :machine_cult
      cost 5

      primary do
        combat 4
        scrap_card_from_hand_or_discard_pile optional: true
      end

      ally do
        draw 1
      end
    end
  end
end
