module Realms
  module Effects
    class CustomEffect < Effect
      def self.auto?
        false
      end

      def key
        definition.effect_key
      end
    end
  end
end
