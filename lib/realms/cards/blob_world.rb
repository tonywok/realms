module Realms
  module Cards
    class BlobWorld < Card
      type :base
      defense 7
      faction :blob
      cost 8

      primary do
        choose do
          combat 5
          draw_for_each_blob_card_played_this_turn
        end
      end
    end
  end
end
