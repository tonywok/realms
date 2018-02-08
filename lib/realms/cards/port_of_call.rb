module Realms
  module Cards
    class PortOfCall < Card
      include Framework::Cards::Dsl

      type :outpost
      defense 6
      faction :trade_federation
      cost 6

      primary do
        trade 3
      end

      scrap do
        draw 1
        destroy_target_base optional: true
      end
    end
  end
end
