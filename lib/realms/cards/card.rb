require "realms/abilities"
require "realms/actions"
require "equalizer"

require "realms/cards/dsl"

module Realms
  module Cards
    class Card
      include Brainguy::Observable

      module Factions
        ALL = [
          BLOB = :blob,
          TRADE_FEDERATION = :trade_federation,
          MACHINE_CULT = :machine_cult,
          STAR_ALLIANCE = :star_alliance,
        ]
        UNALIGNED = :unaligned

        def self.valid?(faction)
          ALL.include?(faction) || faction == UNALIGNED
        end
      end

      class CardConfigurationError < StandardError; end

      class CardDefinition
        attr_accessor :type,
                      :defense,
                      :cost,
                      :factions,
                      :primary_abilities,
                      :ally_abilities,
                      :scrap_abilities

        def initialize
          @type = :ship
          @defense = 0 # TODO: there's probably a class in here
          @cost = 0
          @factions = Set.new
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

        def initialize_copy(source)
          super
          @factions = source.factions.dup
          @primary_abilities = source.primary_abilities.dup
          @ally_abilities = source.ally_abilities.dup
          @scrap_abilities = source.scrap_abilities.dup
        end
      end

      include Equalizer.new(:key)

      def self.definition
        @definition ||= CardDefinition.new
      end

      def self.type(type)
        definition.type = type
      end

      def self.faction(faction)
        raise CardConfigurationError, "invalid faction: #{faction}" unless Factions.valid?(faction)
        definition.factions << faction
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

      def self.key
        to_s.demodulize.underscore
      end

      def self.scrap_ability(klass, optional: false)
        klass = Abilities::Optional[klass] if optional
        definition.scrap_abilities << klass
      end

      attr_reader :key
      attr_accessor :owner, :definition

      delegate :type,
               :factions,
               :cost,
               :defense,
               to: :definition

      def initialize(owner, index: 0)
        @key = "#{name}_#{index}".to_sym
        @owner = owner
        @definition = self.class.definition
      end

      def name
        self.class.key
      end

      def zone
        if_none = ->() { raise "card lost: #{self}" }
        owner.zones.find(if_none) { |z| z.include?(self) }
      end

      def primary_ability(turn)
        ability = case definition.primary_ability
                  when Framework::Abilities::Definition
                    definition.primary_ability.to_ability(self, turn)
                  else
                    definition.primary_ability.new(self, turn)
                  end
        ability.tap { emit(:primary_ability, self) }
      end

      def ally_ability(turn)
        ability = case definition.ally_ability
                  when Framework::Abilities::Definition
                    definition.ally_ability.to_ability(self, turn)
                  else
                    definition.ally_ability.new(self, turn)
                  end
        ability.tap { emit(:ally_ability, self) }
      end

      def definition=(definition)
        @definition = definition
        emit(:definition_change, self)
      end

      def scrap_ability(turn)
        definition.scrap_ability.new(self, turn)
      end

      def ally_factions
        factions
      end

      def primary_ability?
        definition.primary_abilities.any?
      end

      def scrap_ability?
        definition.scrap_abilities.any?
      end

      def ally_ability?
        definition.ally_abilities.any?
      end

      def automatic_primary_ability?
        ship? || static? || definition.primary_abilities.any?(&:auto?)
      end

      def automatic_ally_ability?
        definition.ally_abilities.any?(&:auto?)
      end

      def blob?
        factions.include?(:blob)
      end

      def static?
        definition.primary_abilities.any?(&:static?)
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

      def ally?(other)
        return false if self == other
        (ally_factions & other.ally_factions).present?
      end

      def inspect
        key
      end

      protected

      def <=>(other_card)
        self.key <=> other_card.key
      end
    end
  end
end
