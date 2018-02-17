module Realms
  module Cards
    class PatrolMech < Card
      faction :machine_cult
      cost 4

      primary do
        choose do
          trade 3
          combat 5
        end
      end

      ally do
        scrap_card_from_hand_or_discard_pile optional: true
      end
    end
  end
end
