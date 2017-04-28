module Realms
  module Abilities
    class DrawForEachBlobCardPlayedThisTurn < Ability
      def self.key
        :draw_for_each_blob_card_played_this_turn
      end

      def execute
        # TODO this is not sufficient
        num = turn.active_player.deck.in_play.select(&:blob?).length
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
