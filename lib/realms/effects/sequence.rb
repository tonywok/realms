module Realms
  module Effects
    class Sequence < Effect
      def execute
        effects.each do |effect|
          perform effect.to_effect(card, turn)
        end
      end
    end
  end
end
