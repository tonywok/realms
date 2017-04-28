require "realms/zones/transfer"

module Realms
  module Zones
    class Zone
      attr_accessor :owner, :cards

      include Enumerable
      include Wisper::Publisher

      delegate :include?, :shuffle!, :empty?, :first, :last, :length, :sample, :delete, :remove, :index,
        :insert, :concat, :second,
        to: :cards

      delegate :active_turn,
        to: :owner

      def <<(card)
        self.cards << card
      end

      def each(&block)
        cards.each(&block)
      end

      def initialize(owner, cards = [])
        @owner = owner
        @cards = cards
        subscribe(self)
      end

      def actions
        []
      end

      def transfer!(card: first, to:, pos: to.length)
        zt = Transfer.new(card: card, source: self, destination: to, destination_position: pos)
        broadcast(:before_card_removed, zt)
        zt.transfer!
        broadcast(:on_card_removed, zt)
        to.send(:broadcast, :on_card_added, zt)
      end

      def remove(card)
        cards.delete_at(cards.index(card) || cards.length)
      end
    end
  end
end
