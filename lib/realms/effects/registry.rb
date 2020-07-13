require "realms/effects/definition"

module Realms
  module Effects
    class Registry
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
        @registrations.merge!(key => Definition.new(key: key, **kwargs, &block)) do |_|
          raise("#{key} is already registered")
        end
      end
    end
  end
end