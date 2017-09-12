module Realms
  module Abilities
    class CopyShip < Ability
      def self.key
        :copy_ship
      end

      def execute
        choose(ships) do |ship|
          card.definition = ship.definition.clone.tap do |definition|
            card.factions.each { |faction| definition.factions << faction }
          end
          perform Actions::PrimaryAbility.new(turn, card)
        end
      end

      def ships
        active_player.in_play.select(&:ship?).index_by(&:key).except(card.key).values
      end
    end
  end
end
