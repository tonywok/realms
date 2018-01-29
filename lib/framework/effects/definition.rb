module Framework
  module Effects
    class Definition
      attr_reader :effect_class, :num

      def initialize(effect_class, num)
        @effect_class = effect_class
        @num = num
      end

      def to_effect(card, turn)
        effect_class[num].new(card, turn)
      end
    end
  end
end
