require "realms/turns/declarations/phase"
require "realms/turns/phases/definition"
require "realms/turns/structure"

module Realms
  module Turns
    class Builder
      include Flows::Builder

      def phase(key, actions: [], &execution)
        definition = Phases::Definition.new(key: key, actions: actions, execution: execution)
        declarations << Declarations::Phase.new(definition: definition)
      end

      def to_definition
        Structure.new(:declaration => Flows::Declarations::Sequence.new(declarations: declarations))
      end
    end
  end
end