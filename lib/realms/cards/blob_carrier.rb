module Realms
  module Cards
    class BlobCarrier < Card
      faction :blob
      cost 6

      primary do
        combat 7
      end

      ally do
        acquire_ship_and_top_deck 
      end
    end
  end
end
