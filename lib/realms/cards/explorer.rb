module Realms
  module Cards
    class Explorer < Card
      include Framework::Cards::Dsl

      faction :unaligned
      cost 2

      primary do
        trade 2
      end

      scrap do
        combat 2
      end
    end
  end
end
