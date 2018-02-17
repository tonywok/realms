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
          effect(:draw_for_each_blob_card_played_this_turn) do
            num = active_player.in_play.cards_in_play.count do |c|
              c.played_this_turn? && c.blob?
            end
            active_player.draw(num)
          end
        end
      end
    end
  end
end
