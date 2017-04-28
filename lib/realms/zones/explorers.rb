module Realms
  module Zones
    class Explorers < Zone
      def initialize(*args)
        super
        @cards = 10.times.map { |i| Cards::Explorer.new(owner, index: i) }
      end

      def actions(turn)
        return [] unless turn.trade >= Cards::Explorer.definition.cost
        [Actions::AcquireCard.new(turn, cards.first)]
      end
    end
  end
end
