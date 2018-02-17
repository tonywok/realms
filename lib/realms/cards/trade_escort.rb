module Realms
  module Cards
    class TradeEscort < Card
      faction :trade_federation
      cost 5

      primary do
        authority 4
        combat 4
      end

      ally do
        draw 1
      end
    end
  end
end
