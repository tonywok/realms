module Realms
  module Abilities
    class AllShipsGetCombat < Ability
      def self.key
        :all_ships_combat
      end

      def self.static?
        true
      end

      def execute
        card.owner.in_play.events.attach(self)
      end

      def on_card_added(event)
        played_card = event.args.first.card
        if played_card.ship?
          played_card.definition = played_card.definition.dup.tap do |defn|
            defn.primary_abilities << Abilities::Combat[arg]
          end
        end
      end

      def on_card_removed(event)
        card.owner.in_play.events.detach(self)
      end
    end
  end

  module Cards
    class FleetHQ < Card
      faction Factions::STAR_ALLIANCE
      type :base
      defense 8
      cost 8
      primary_ability Abilities::AllShipsGetCombat[1]
    end
  end
end
