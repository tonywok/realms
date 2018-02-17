module Realms
  module Cards
    class Ram < Card
      faction :blob
      cost 3

      primary do
        combat 5
      end

      ally do
        combat 2
      end

      scrap do
        trade 3
      end
    end
  end
end
