module Realms
  module Abilities
    class DrawForEachBlobCardPlayedThisTurn < Ability
      def self.key
        :draw_for_each_blob_card_played_this_turn
      end

      def execute
        num = active_player.in_play.select { |c| c.played_this_turn? && c.blob? }.length
        turn.active_player.draw(num)
      end
    end
  end

  module Cards
    class BlobWorld < Card
      type :base
      defense 7
      faction :blob
      cost 8
      primary_ability Abilities::Choose[
        Abilities::Combat[5],
        Abilities::DrawForEachBlobCardPlayedThisTurn
      ]
    end
  end
end
