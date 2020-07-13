require "realms/cards/builder"

module Realms
  module Cards
    module Dsl
      extend ActiveSupport::Concern

      class_methods do
        def definition
          @definition ||= builder.to_definition
        end

        def builder
          @builder ||= Builder.new
        end

        def faction(*factions)
          builder.factions.merge(factions)
        end

        def cost(trade_amount)
          builder.cost = trade_amount
        end

        def type(card_type)
          builder.type = card_type
        end

        def defense(num)
          builder.defense = num
        end

        def primary(&block)
          builder.primary(&block)
        end

        def ally(&block)
          builder.ally(&block)
        end

        def scrap(&block)
          builder.scrap(&block)
        end
      end
    end
  end
end
