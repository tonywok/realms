module Realms
  module Cards
    class EmbassyYacht < Card
      faction :trade_federation
      cost 3

      primary do
        authority 3
        trade 2
        draw_two_if_two_bases
      end
    end
  end
end
