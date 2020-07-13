module Realms
  module Effects
    class Definition
      attr_reader :key, :execution, :auto

      def initialize(key:, auto: false, &block)
        @key = key
        @auto = auto
        @execution = block
      end

      def auto?
        !!auto
      end
    end
  end
end