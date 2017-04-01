module Realms
  class ZoneTransfer
    include Wisper::Publisher

    attr_accessor :source, :destination, :card, :position

    def initialize(source:, destination:, card: source.first)
      @source = source
      @destination = destination
      @card = card
      @position = destination.length
    end

    def transfer!(pos = position)
      raise InvalidTarget, card if !source.include?(card) || destination.include?(card)
      broadcast(:zone_transfer, self)
      destination.insert(pos, source.remove(card))
    end
  end

  class Zone
    attr_accessor :cards

    include Enumerable

    delegate :include?, :shuffle!, :empty?, :first, :last, :length, :sample, :delete, :remove, :index,
      :insert, :concat, :second,
      to: :cards

    def <<(card)
      self.cards << card
    end

    def each(&block)
      cards.each(&block)
    end

    def initialize(cards = [])
      @cards = cards
    end

    def transfer!(card: first, to:, pos: to.length)
      ZoneTransfer.new(card: card, source: self, destination: to).transfer!(pos)
    end

    def remove(card)
      cards.delete_at(cards.index(card) || cards.length)
    end
  end
end
