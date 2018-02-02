module Realms
  module Cards
    class BattlePod < Card
      include Framework::Cards::Dsl

      faction :blob
      cost 2

      primary do
        combat 4
        scrap_card_from_trade_row optional: true
      end

      ally do
        combat 2
      end
    end
  end
end
