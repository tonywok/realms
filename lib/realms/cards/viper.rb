module Realms
  module Cards
    class Viper < Card
      include Framework::Cards::Dsl
      faction :unaligned
      cost 0
      primary do
        combat 1
      end
    end
  end
end
