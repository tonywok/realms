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
        card.zone.on(:on_card_added) do |zt|
          played_card = zt.card

          turn.on(:turn_end) { played_card.definition = played_card.class.definition }

          if played_card.ship?
            played_card.definition = played_card.definition.dup.tap do |defn|
              defn.primary_abilities << Abilities::Combat[arg]
            end
          end
        end
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
