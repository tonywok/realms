module Realms
  module Abilities
    class CopyShip < Ability
      def execute
        choose(Choice.new(ships)) do |ship|
          turn.event_manager.add_observer(self)
          card.definition = ship.definition.clone.tap do |defn|
            card.factions.each { |faction| defn.factions << faction }
          end
          perform card.primary_ability
        end
      end

      def ships
        active_player.deck.battlefield.select(&:ship?).each_with_object({}) do |card, opts|
          opts[card.key] = card
        end
      end

      def update(*args)
        card.definition = card.class.definition
        turn.event_manager.delete_observer(self)
      end
    end
  end
end
