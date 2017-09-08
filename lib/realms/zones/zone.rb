require "realms/zones/transfer"

module Realms
  module Zones
    class Zone
      attr_accessor :owner, :cards

      include Enumerable
      include Brainguy::Observable
      include Brainguy::Observer

      delegate :include?, :shuffle!, :empty?, :first, :last, :length, :sample, :delete, :remove, :index,
        :insert, :concat, :second,
        to: :cards

      delegate :active_turn, :next_transfer_id,
        to: :registry

      def <<(card)
        null_zone.transfer!(card: card, to: self)
      end

      def each(&block)
        cards.each(&block)
      end

      def initialize(registry, owner, cards = [])
        @registry = registry
        @owner = owner
        @cards = cards
        events.attach(self)
      end

      def key
        [owner.key, self.class.to_s.demodulize.underscore].join(".")
      end

      def actions
        []
      end

      def transfer!(card: first, to:, pos: to.length)
        zt = Transfer.new(card: card, source: self, destination: to, destination_position: pos)

        emit(:removing_card, zt)
        zt.transfer!
        emit(:card_removed, zt)
        to.send(:emit, :card_added, zt)
      end

      def remove(card)
        cards.delete_at(cards.index(card) || cards.length)
      end

      def inspect
        "<#{self.class} cards=#{cards}>"
      end

      private

      attr_reader :registry

      def null_zone
        @null_zone ||= Null.new(self, owner)
      end
    end
  end
end
