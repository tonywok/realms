module Realms
  module Cards
    class TradingPost < Card
      include Framework::Cards::Dsl

      type :outpost
      defense 4
      faction :trade_federation
      cost 3

      primary do
        choose do
          authority 1
          trade 1
        end
      end

      scrap do
        combat 3
      end
    end
  end
end
