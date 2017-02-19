module Realms2
  module Abilities
    class Multi < Ability
      def execute
        arg.each do |ability_klass|
          perform ability_klass.new(player)
        end
      end
    end
  end
end
