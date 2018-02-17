module Realms
  module Effects
    module Definitions
      class Numeric < Definition
        attr_reader :effect_class, :num, :effects, :optionality

        def initialize(effect_class, num, optionality: false)
          super(effect_class, optionality: optionality)
          @num = num
        end

        def draw(num)
          effects << self.class.new(Draw, num)
        end

        def discard(num = 1)
          effects << self.class.new(Discard, num)
        end

        def scrap_card_from_hand_or_discard_pile(optional: false)
          effects << self.class.new(ScrapFromHandOrDiscardPile, nil, optionality: optional)
        end

        def scrap_card_from_trade_row(optional: false)
          effects << self.class.new(ScrapCardFromTradeRow, nil, optionality: optional)
        end

        def destroy_target_base(optional: false)
          effects << self.class.new(DestroyTargetBase, nil, optionality: optional)
        end

        def copy_ship
          #TODO
        end

        def top_deck_next_ship(optional: false)
          effects << self.class.new(TopDeckNextShip, nil, optionality: optional)
        end

        def discard_to_draw(num, optional: false)
          # TODO
        end
      end
    end
  end
end
