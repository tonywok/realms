module Realms
  module Choices
    class Option
      attr_reader :key, :value

      def initialize(key:, value: nil)
        @key = key
        @value = value
      end

      def noop?
        value.nil?
      end

      def inspect
        "Option #{value.inspect}"
      end
    end
  end
end
