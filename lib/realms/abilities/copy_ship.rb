module Realms
  module Abilities
    class CopyShip < Ability
      def self.key
        :copy_ship
      end

      def execute
        choose(Choice.new(ships)) do |ship|
          card.definition = ship.definition.clone.tap do |definition|
            card.factions.each { |faction| definition.factions << faction }
          end
          perform card.primary_ability
        end
      end

      def ships
        active_player.deck.in_play.select(&:ship?)
      end
    end
  end
end
