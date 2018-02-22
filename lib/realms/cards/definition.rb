module Realms
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

      def initialize_copy(source)
        super
        @factions = source.factions.dup
        @primary_ability = source.primary_ability&.dup
        @ally_ability = source.ally_ability&.dup
        @scrap_ability = source.scrap_ability&.dup
      end
    end
  end
end
