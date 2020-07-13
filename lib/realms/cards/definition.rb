module Realms
  module Cards
    class Definition
      attr_reader :factions,
                  :type,
                  :cost,
                  :defense,
                  :primary_ability,
                  :ally_ability,
                  :scrap_ability

      def initialize(factions:, type:, cost:, defense:, primary_ability:, ally_ability:, scrap_ability:)
        @factions = factions
        @type = type
        @cost = cost
        @defense = defense
        @primary_ability = primary_ability
        @ally_ability = ally_ability
        @scrap_ability = scrap_ability
      end
    end
  end
end