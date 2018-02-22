module Realms
  module Effects
    module Definitions
      class Definition
        attr_reader :effect_class, :effects, :optionality

        def initialize(effect_class, optionality: false)
          @effect_class = effect_class
          @effects = []
          @optionality = optionality
        end

        def initialize_copy(source)
          super
          @effects = source.effects.dup
        end

        def auto?
          effects.flat_map(&:effect_class).all?(&:auto?)
        end

        def to_effect(card, turn)
          effect_class.new(self, card, turn, optional: optionality)
        end

        def choose(&block)
          # TODO: more specific effect definitions
          effect = self.class.new(Choose)
          effect.instance_exec(&block)
          effects << effect
        end

        def effect(effect_key, optional: false, &block)
          custom_effect = Custom.new(effect_key, optional, &block)
          effects << custom_effect
        end

        def trade(num)
          effects << Numeric.new(Trade, num)
        end

        def combat(num)
          effects << Numeric.new(Combat, num)
        end

        def authority(num)
          effects << Numeric.new(Authority, num)
        end

        def draw(num)
          effects << Numeric.new(Draw, num)
        end

        def discard(num = 1)
          effects << Numeric.new(Discard, num)
        end

        def scrap_card_from_hand_or_discard_pile(num = 1, optional: false)
          effects << Numeric.new(ScrapFromHandOrDiscardPile, num, optionality: optional)
        end

        def scrap_card_from_trade_row(num = 1, optional: false)
          effects << Numeric.new(ScrapCardFromTradeRow, num, optionality: optional)
        end

        def destroy_target_base(optional: false)
          effects << self.class.new(DestroyTargetBase, optionality: optional)
        end

        def top_deck_next_ship(optional: false)
          effects << self.class.new(TopDeckNextShip, optionality: optional)
        end

        def all_ships_get_combat
          effects << self.class.new(AllShipsGetCombat)
        end
      end
    end
  end
end
