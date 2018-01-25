module Realms
  module Cards
    class Scout < Card
      include ::Framework::Cards::Dsl

      faction :unaligned
      cost 0
      primary do
        trade 1
      end
    end
  end
end
