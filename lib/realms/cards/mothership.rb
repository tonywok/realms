module Realms
  module Cards
    class Mothership < Card
      include Framework::Cards::Dsl

      faction :blob
      cost 7

      primary do
        combat 6
        draw 1
      end

      ally do
        draw 1
      end
    end
  end
end
