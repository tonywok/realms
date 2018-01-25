module Realms
  module Cards
    module Dsl
      extend ActiveSupport::Concern

      class_methods do
        def definition
          @definition ||= CardDefinition.new
        end

        def faction(*factions)
          definition.factions.merge(factions)
        end

        def cost(trade_amount)
          definition.cost = trade_amount
        end

        def primary(&block)
          ability_definition = AbilityDefinition.new
          ability_definition.instance_exec(&block)
          definition.primary_ability = ability_definition
        end
      end

      class AbilityDefinition
        def to_ability(card, turn)
          SequenceAbility.new(self, card, turn)
        end

        def effects
          @effects ||= []
        end

        def trade(num)
          effects << EffectDefinition.new(::Realms::Abilities::Trade, num)
        end

        class EffectDefinition
          attr_reader :effect_class, :num

          def initialize(effect_class, num)
            @effect_class = effect_class
            @num = num
          end

          def to_effect(card, turn)
            effect_class[num].new(card, turn)
          end
        end

        class SequenceAbility < ::Realms::Abilities::Ability
          attr_reader :definition
          delegate :effects, to: :definition

          def initialize(definition, card, turn)
            @definition = definition
            super(card, turn)
          end

          def execute
            effects.each do |effect|
              perform effect.to_effect(card, turn)
            end
          end
        end
      end

      class CardDefinition
        attr_reader :config,
                    :factions,
                    :type

        attr_accessor :cost, :primary_ability

        delegate :primary_abilities,
                 :ally_abilities, :ally_ability,
                 :scrap_abilities, :scrap_ability,
                 to: :config

        def initialize
          @config = Config.new(self)
          @factions = Set.new
          @cost = 0
          @type = :ship
        end

        private

        class Config
          attr_reader :card_def

          def initialize(card_def)
            @card_def = card_def
          end

          def primary_abilities
            [Abilities::Trade[1]]
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
  end
end
