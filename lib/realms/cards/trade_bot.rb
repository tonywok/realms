module Realms
  module Cards
    class TradeBot < Card
      faction :machine_cult
      cost 1

      primary do
        trade 1
        scrap_from_hand_or_discard_pile optional: true
      end

      ally do
        combat 2
      end
    end
  end
end
