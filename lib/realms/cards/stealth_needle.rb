module Realms
  module Cards
    class StealthNeedle < Card
      include Framework::Cards::Dsl

      faction :machine_cult
      cost 4

      primary do
        copy_ship
      end
    end
  end
end
