module Realms
  module Effects
    class Numeric < Effect
      delegate :num, to: :definition
    end
  end
end
