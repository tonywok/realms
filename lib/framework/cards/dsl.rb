module Framework
  module Cards
    # TODO: this is realms specific
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

        def type(card_type)
          definition.type = card_type
        end

        def defense(num)
          definition.defense = num
        end

        def primary(&block)
          ability_definition = Effects::Definition.new(Effects::PrimaryAbility, nil)
          ability_definition.instance_exec(&block)
          definition.primary_ability = ability_definition
        end

        def ally(&block)
          ability_definition = Effects::Definition.new(Effects::AllyAbility, nil)
          ability_definition.instance_exec(&block)
          definition.ally_ability = ability_definition
        end

        def scrap(&block)
          ability_definition = Effects::Definition.new(Effects::ScrapAbility, nil)
          ability_definition.instance_exec(&block)
          definition.scrap_ability = ability_definition
        end
      end
    end
  end
end
