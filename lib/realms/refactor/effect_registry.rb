module Realms
  module Refactor
    class EffectRegistry
      attr_reader :registrations

      def self.configure(&block)
        registry = new
        registry.instance_exec(&block)
        registry
      end

      def initialize
        @registrations = {}
      end

      def effect(key, **kwargs, &block)
        @registrations.merge!(key => EffectDefinition.new(key: key, **kwargs, &block)) do |_|
          raise("#{key} is already registered")
        end
      end

      class EffectDefinition
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
end