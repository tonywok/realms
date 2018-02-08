module Realms
  module Cards
    class BlobWheel < Card
      include Framework::Cards::Dsl

      type :base
      defense 5
      faction :blob
      cost 3

      primary do
        combat 1
      end

      scrap do
        trade 3
      end
    end
  end
end
