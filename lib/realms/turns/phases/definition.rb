module Realms
  module Turns
    module Phases
      class Definition
        attr_reader :key, :execution, :actions

        def initialize(key:, actions:, execution:)
          @key = key
          @execution = execution
          @actions = actions
        end
      end
    end
  end
end