module Realms
  module Zones
    class Explorers < Zone
      attr_reader :explorers

      def initialize(*args)
        super
        @explorers = (0..Float::INFINITY).lazy.map do |i|
          Cards::Explorer.new(owner, index: i)
        end
      end

      def cards
        [explorers.peek]
      end

      def remove(card)
        explorers.next
      end

      def actions
        return [] unless active_turn.trade >= Cards::Explorer.definition.cost
        [Actions::AcquireCard.new(active_turn, cards.first)]
      end
    end
  end
end
