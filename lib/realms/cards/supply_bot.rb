module Realms
  module Cards
    class SupplyBot < Card
      include Framework::Cards::Dsl

      faction :machine_cult
      cost 3

      primary do
        trade 2
        scrap_card_from_hand_or_discard_pile optional: true
      end

      ally do
        combat 2
      end
    end
  end
end
