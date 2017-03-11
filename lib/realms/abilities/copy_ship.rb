module Realms
  module Abilities
    class CopyShip
      def execute
        choose(Choice.new(ships)) do |card|
          # copy!
        end
      end

      def ships
        active_player.deck.battlefield.select(&:ship?).each_with_object({}) do |card, opts|
          opts[card.key] = card
        end
      end
    end
  end
end
