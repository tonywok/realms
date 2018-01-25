module Framework
  module Cards
    module Dsl
      extend ActiveSupport::Concern

      class_methods do
        def definition
          @definition ||= Definition.new
        end

        def faction(*factions)
          definition.factions.merge(factions)
        end

        def cost(trade_amount)
          definition.cost = trade_amount
        end

        def primary(&block)
          ability_definition = Abilities::Definition.new
          ability_definition.instance_exec(&block)
          definition.primary_ability = ability_definition
        end
      end
    end
  end
end
