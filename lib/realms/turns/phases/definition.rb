module Realms
  module Turns
    module Phases
      class Definition
        attr_reader :key, :execution

        def initialize(key:, execution:)
          @key = key
          @execution = execution
        end
      end
    end
  end
end