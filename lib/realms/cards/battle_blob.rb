module Realms
  module Cards
    class BattleBlob < Card
      faction :blob
      cost 6

      primary do
        combat 8
      end

      ally do
        draw 1
      end

      scrap do
        combat 4
      end
    end
  end
end
