module Framework
  module Cards
    class Definition
      attr_reader :factions,
                  :type

      attr_accessor :cost, :primary_ability

      def initialize
        @factions = Set.new
        @cost = 0
        @type = :ship
      end

      def primary_abilities
        ["derp"]
      end

      def ally_abilities
        []
      end

      def scrap_abilities
        []
      end
    end
  end
end
