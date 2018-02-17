module Realms
  module Cards
    class TheHive < Card
      type :base
      defense 5
      faction :blob
      cost 5

      primary do
        combat 3
      end

      ally do
        draw 1
      end
    end
  end
end
