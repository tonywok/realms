require_relative "definition"
require_relative "ability_builder"

module Realms
  module Refactor
    class Builder
      attr_accessor :cost,
                    :factions,
                    :primary_ability,
                    :ally_ability,
                    :scrap_ability,
                    :type,
                    :defense

      def initialize
        @factions = Set.new
        @cost = 0
        # TODO: different types of definitions
        @type = :ship
      end

      def primary(&block)
        ability_builder = AbilityBuilder.new
        ability_builder.instance_exec(&block)
        self.primary_ability = ability_builder.to_definition
      end

      def ally(&block)
        ability_builder = AbilityBuilder.new
        ability_builder.instance_exec(&block)
        self.ally_ability = ability_builder.to_definition
      end

      def scrap(&block)
        ability_builder = AbilityBuilder.new
        ability_builder.instance_exec(&block)
        self.scrap_ability = ability_builder.to_definition
      end

      def to_definition
        Definition.new(
          :factions => factions,
          :type => type,
          :cost => cost,
          :defense => defense,
          :primary_ability => primary_ability,
          :ally_ability => ally_ability,
          :scrap_ability => scrap_ability
        )
      end
    end
  end
end