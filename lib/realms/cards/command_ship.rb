module Realms
  module Cards
    class CommandShip < Card
      include Framework::Cards::Dsl

      faction :trade_federation
      cost 8

      primary do
        authority 4
        combat 5
        draw 2
      end

      ally do
        destroy_target_base optional: true
      end
    end
  end
end
