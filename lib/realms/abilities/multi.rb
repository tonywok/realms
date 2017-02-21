module Realms
  module Abilities
    class Multi < Ability
      def execute
        arg.each do |ability_klass|
          perform ability_klass.new(turn)
        end
      end
    end
  end
end
