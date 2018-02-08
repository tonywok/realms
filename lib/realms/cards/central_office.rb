module Realms
  module Cards
    class CentralOffice < Card
      include Framework::Cards::Dsl

      type :base
      defense 6
      faction :trade_federation
      cost 7

      primary do
        trade 2
        top_deck_next_ship optional: true
      end

      ally do
        draw 1
      end
    end
  end
end
