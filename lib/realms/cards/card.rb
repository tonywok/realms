require "realms/abilities"
require "realms/actions"

module Realms
  module Cards
    class Card
      class CardDefinition
        attr_accessor :faction,
                      :cost,
                      :primary_abilities,
                      :ally_abilities,
                      :scrap_abilities

        def initialize
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

      def self.faction(faction)
        definition.faction = faction
      end

      def self.cost(num)
        definition.cost = num
      end

      def self.primary_ability(klass, optional: false)
        definition.primary_abilities << klass
      end

      def self.ally_ability(klass, optional: false)
        definition.ally_abilities << klass
      end

      def self.scrap_ability(klass, optional: false)
        definition.scrap_abilities << klass
      end

      attr_reader :key, :player, :definition

      delegate :faction,
               :cost,
               :primary_ability,
               :ally_ability,
               to: :definition

      def initialize(player = Player::Unclaimed.instance, index: 0)
        @key = "#{self.class.to_s.demodulize.underscore}_#{index}".to_sym
        @player = player
        @definition = self.class.definition
      end

      def base?
        false
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
