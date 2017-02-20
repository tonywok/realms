module Realms
  module Phases
    class Discard < Phase
      def execute
        # 1. lose all trade
        # 2. lose all combat
        # 3. put all in-play ships into your discard pile
        # 4. put any cards left in your hand into your discard pile
      end
    end
  end
end
