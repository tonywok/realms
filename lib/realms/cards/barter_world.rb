module Realms
  module Cards
    class BarterWorld < Card
      type :base
      defense 4
      faction :trade_federation
      cost 4

      primary do
        choose do
          authority 2
          trade 2
        end
      end

      scrap do
        combat 5
      end
    end
  end
end
