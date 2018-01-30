module Framework
  module Cards
    class Definition
      attr_reader :factions,
                  :type

      attr_accessor :cost,
                    :primary_ability,
                    :ally_ability

      def initialize
        @factions = Set.new
        @cost = 0
        @type = :ship
      end

      def primary_abilities
        primary_ability.effects
      end

      def ally_abilities
        ally_ability.effects
      end

      def scrap_abilities
        []
      end
    end
  end
end
