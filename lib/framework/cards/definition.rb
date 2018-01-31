module Framework
  module Cards
    class Definition
      attr_reader :factions

      attr_accessor :cost,
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

      def primary_abilities
        Array.wrap(primary_ability&.effects)
      end

      def ally_abilities
        Array.wrap(ally_ability&.effects)
      end

      def scrap_abilities
        Array.wrap(scrap_ability&.effects)
      end
    end
  end
end
