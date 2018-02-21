require "equalizer"

module Realms
  module Cards
    class Card
      include Dsl
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

      include Equalizer.new(:key)

      def self.key
        to_s.demodulize.underscore
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
        definition.primary_ability.to_effect(self, turn).tap do
          emit(:primary_ability, self)
        end
      end

      def ally_ability(turn)
        definition.ally_ability.to_effect(self, turn).tap do
          emit(:ally_ability, self)
        end
      end

      def definition=(definition)
        @definition = definition
        emit(:definition_change, self)
      end

      def scrap_ability(turn)
        definition.scrap_ability.to_effect(self, turn).tap do
          emit(:scrap_ability, self)
        end
      end

      def ally_factions
        factions
      end

      def primary_ability?
        definition.primary_ability.present?
      end

      def scrap_ability?
        definition.scrap_ability.present?
      end

      def ally_ability?
        definition.ally_ability.present?
      end

      def automatic_primary_ability?
        return false unless primary_ability?
        ship? || definition.primary_ability.auto?
      end

      def automatic_ally_ability?
        return false unless ally_ability?
        definition.ally_ability.auto?
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
