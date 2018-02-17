module Realms
  module Cards
    class BlobFighter < Card
      faction :blob
      cost 1

      primary do
        combat 3
      end

      ally do
        draw 1
      end
    end
  end
end
