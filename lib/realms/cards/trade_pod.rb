module Realms
  module Cards
    class TradePod < Card
      include Framework::Cards::Dsl

      faction :blob
      cost 2

      primary do
        trade 3
      end

      ally do
        combat 2
      end
    end
  end
end
