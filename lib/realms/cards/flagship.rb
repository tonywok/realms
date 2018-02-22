module Realms
  module Cards
    class Flagship < Card
      faction :trade_federation
      cost 6

      primary do
        combat 5
        draw 1
      end

      ally do
        authority 5
      end
    end
  end
end
