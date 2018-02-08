module Realms
  module Cards
    class FederationShuttle < Card
      include Framework::Cards::Dsl

      faction :trade_federation
      cost 1

      primary do
        trade 2
      end

      ally do
        authority 4
      end
    end
  end
end
