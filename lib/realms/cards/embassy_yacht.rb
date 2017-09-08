module Realms
  module Abilities
    class DrawTwoCardsIfTwoBases < Ability
      def execute
        active_player.draw(2) if active_player.in_play.count(&:base?) >= 2
      end
    end
  end

  module Cards
    class EmbassyYacht < Card
      faction :trade_federation
      cost 3
      primary_ability Abilities::Authority[3]
      primary_ability Abilities::Trade[2]
      primary_ability Abilities::DrawTwoCardsIfTwoBases
    end
  end
end
