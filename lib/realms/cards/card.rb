require "realms/abilities"
require "realms/actions"

module Realms
  module Cards
    class Card
      class CardDefinition
        attr_accessor :type,
                      :defense,
                      :faction,
                      :cost,
                      :primary_abilities,
                      :ally_abilities,
                      :scrap_abilities

        def initialize
          @type = :ship
          @defense = 0 # TODO: there's probably a class in here
          @faction = :unaligned
          @cost = 0
          @primary_abilities = []
          @ally_abilities = []
          @scrap_abilities = []
        end

        def primary_ability
          return primary_abilities.first unless primary_abilities.many?
          Abilities::Multi[primary_abilities]
        end

        def ally_ability
          return ally_abilities.first unless ally_abilities.many?
          Abilities::Multi[ally_abilities]
        end

        def scrap_ability
          return scrap_abilities.first unless scrap_abilities.many?
          Abilities::Multi[scrap_abilities]
        end
      end

      def self.definition
        @definition ||= CardDefinition.new
      end

      def self.type(type)
        definition.type = type
      end

      def self.faction(faction)
        definition.faction = faction
      end

      def self.cost(num)
        definition.cost = num
      end

      def self.defense(num)
        definition.defense = num
      end

      def self.primary_ability(klass, optional: false)
        klass = Abilities::Optional[klass] if optional
        definition.primary_abilities << klass
      end

      def self.ally_ability(klass, optional: false)
        klass = Abilities::Optional[klass] if optional
        definition.ally_abilities << klass
      end

      def self.scrap_ability(klass, optional: false)
        klass = Abilities::Optional[klass] if optional
        definition.scrap_abilities << klass
      end

      attr_reader :key, :definition
      attr_accessor :player

      delegate :type,
               :faction,
               :cost,
               :defense,
               to: :definition

      def initialize(player = Player::Unclaimed.instance, index: 0)
        @key = "#{self.class.to_s.demodulize.underscore}_#{index}".to_sym
        @player = player
        @definition = self.class.definition
      end

      def primary_ability
        definition.primary_ability.new(self, player.active_turn)
      end

      def ally_ability
        definition.ally_ability.new(self, player.active_turn)
      end

      def scrap_ability
        definition.scrap_ability.new(self, player.active_turn)
      end

      def blob?
        faction == :blob
      end

      def ship?
        type == :ship
      end

      def base?
        [:base, :outpost].include?(type)
      end

      def outpost?
        type == :outpost
      end

      def ally_ability_activated?
        return false if faction == :unaligned
        (player.deck.battlefield - [self]).any? { |card| card.faction == faction }
      end

      def inspect
        key
      end
    end
  end
end
