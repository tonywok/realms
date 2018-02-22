module Realms
  module Cards
    class Cutter < Card
      faction :trade_federation
      cost 2

      primary do
        authority 4
        trade 2
      end

      ally do
        combat 4
      end
    end
  end
end
