module Realms
  module Abilities
    class CopyShip < Ability
      def execute
        choose(Choice.new(ships)) do |ship|
          turn.event_manager.add_observer(self)

          new_definition = Cards::Card::CardDefinition.new
          old_definition = ship.definition

          new_definition.primary_abilities << old_definition.primary_ability
          new_definition.ally_abilities << old_definition.ally_ability
          new_definition.scrap_abilities << old_definition.scrap_ability
          (old_definition.factions + card.factions).each do |faction|
            new_definition.factions << faction
          end

          new_definition.cost = old_definition.cost
          card.definition = new_definition

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
