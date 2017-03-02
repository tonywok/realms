module Realms
  module Abilities
    class Optional < Ability
      def execute
        perform arg.new(card, turn, optional: true)
      end
    end
  end
end
