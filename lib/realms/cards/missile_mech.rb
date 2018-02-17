module Realms
  module Cards
    class MissileMech < Card
      faction :machine_cult
      cost 6

      primary do
        combat 6
        destroy_target_base optional: true
      end

      ally do
        draw 1
      end
    end
  end
end
