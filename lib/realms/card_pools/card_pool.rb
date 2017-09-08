require "realms/cards"

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
    end
  end
end
