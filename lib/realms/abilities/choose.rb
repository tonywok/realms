module Realms
  module Abilities
    class Choose < Ability
      def self.[](*args)
        super(args)
      end

      def execute
        choose(Choice.new(arg, optional: true)) do |ability|
          perform ability.new(card, turn)
        end
      end
    end
  end
end
