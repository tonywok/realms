module Realms
  module Zones
    class Transfer
      attr_accessor :source,
                    :source_position,
                    :destination,
                    :destination_position,
                    :card
      attr_reader :id

      def initialize(source:, destination:, card: source.first, destination_position: destination.length)
        @source = source
        @destination = destination
        @card = card
        @source_position = source.index(card)
        @destination_position = destination_position
      end

      def transfer!
        raise InvalidTarget, card.key if !source.include?(card) || destination.include?(card)
        @id = source.next_transfer_id
        card.owner = destination.owner
        self.card = source.remove(card)
        destination.insert(destination_position, card)
      end
    end
  end
end
