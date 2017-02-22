module Realms
  module Cards
    class BlobDestroyer < Card
      faction :blob
      cost 4
      primary_ability Abilities::Combat[6]

      ship :blob_destroyer, faction: :blob, cost: 4 do
        primary_ability do
          Abilities::Combat[6]
        end

        ally_ability do |player|
          Abilities::DestroyTargetBase.new(player, optional: true)
          Abilities::ScrapCardFromTradeRow.new(player, optional: true)
        end
      end
    end
  end
end
