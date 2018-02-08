module Realms
  module Cards
    class DefenseCenter < Card
      include Framework::Cards::Dsl

      type :outpost
      defense 5
      faction :trade_federation
      cost 5

      primary do
        choose do
          authority 3
          combat 2
        end
      end

      ally do
        combat 2
      end
    end
  end
end
