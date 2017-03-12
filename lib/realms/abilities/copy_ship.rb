module Realms
  module Abilities
    class CopyShip < Ability
      def self.key
        :copy_ship
      end

      def execute
        choose(Choice.new(ships)) do |ship|
          turn.event_manager.add_observer(self)
          card.definition = ship.definition.clone.tap do |definition|
            card.factions.each { |faction| definition.factions << faction }
          end
          perform card.primary_ability
        end
      end

      def ships
        active_player.deck.battlefield.select(&:ship?)
      end

      def update(*args)
        card.definition = card.class.definition
        turn.event_manager.delete_observer(self)
      end
    end
  end
end
