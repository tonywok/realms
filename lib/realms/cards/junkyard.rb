module Realms
  module Cards
    class Junkyard < Card
      include Framework::Cards::Dsl

      type :outpost
      defense 5
      faction :machine_cult
      cost 6

      primary do
        scrap_card_from_hand_or_discard_pile optional: true
      end
    end
  end
end
