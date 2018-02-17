module Realms
  module Effects
    module Definitions
      class Custom < Definition
        attr_reader :effect_key, :execute_block

        def initialize(effect_key, optionality, &execute_block)
          @effect_key = effect_key
          super(Class.new(CustomEffect), optionality: optionality)
          effect_class.redefine_method(:execute, &execute_block)
        end

        def to_effect(card, turn)
          effect_class.new(self, card, turn, optional: optionality)
        end

        def auto?
          false
        end
      end
    end
  end
end
