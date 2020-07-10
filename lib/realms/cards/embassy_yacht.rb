module Realms
  module Cards
    class EmbassyYacht < Card
      faction :trade_federation
      cost 3

      primary do
        authority 3
        trade 2
        # effect(:draw_two_if_two_bases) do
        #   active_player.draw(2) if active_player.in_play.count(&:base?) >= 2
        # end
      end
    end
  end
end
