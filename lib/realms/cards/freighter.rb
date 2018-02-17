module Realms
  module Cards
    class Freighter < Card
      faction :trade_federation
      cost 4

      primary do
        trade 4
      end

      ally do
        top_deck_next_ship optional: true
      end
    end
  end
end
