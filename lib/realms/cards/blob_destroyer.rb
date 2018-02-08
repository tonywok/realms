module Realms
  module Cards
    class BlobDestroyer < Card
      include Framework::Cards::Dsl

      faction :blob
      cost 4

      primary do
        combat 6
      end

      ally do
        destroy_target_base optional: true
        scrap_card_from_trade_row optional: true
      end
    end
  end
end
