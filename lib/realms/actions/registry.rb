module Realms
  module Actions
    class Registry
      def configure(&block)
        registry = new
        registry.instance_exec(&block)
        registry
      end

      attr_reader :config

      def initialize
        @config = {}
      end

      def action(key, &block)
        config.merge!(key => Definition.new(key: key, **kwargs, &block)) do |_|
          raise("#{key} is already registered")
        end
      end
    end
  end
end
