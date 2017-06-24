module Realms
  module CardPools
    class CardPool
      include Cards

      def self.cards
        @cards ||= {}
      end

      def self.card(klass, num)
        cards[klass] = num
      end

      attr_reader :cards

      def initialize(trade_deck)
        @cards = self.class.cards.each_with_object([]) do |(klass, num), cards|
          num.times do |i|
            cards << klass.new(trade_deck, index: i)
          end
        end
      end
    end
  end
end
