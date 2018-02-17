module Realms
  module Cards
    class Mothership < Card
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
