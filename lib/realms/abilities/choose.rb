module Realms
  module Abilities
    class Choose < Ability
      def self.[](*args)
        super(args)
      end

      def execute
        choose(Choice.new(abilities, optional: true)) do |ability|
          perform ability.new(card, turn)
        end
      end

      def abilities
        # TODO: really need to const_set these abilities, the anonymous class sucks
        i = 0
        arg.each_with_object({}) do |ability, opts|
          opts["option_#{i}".to_sym] = ability
          i+=1
        end
      end
    end
  end
end
