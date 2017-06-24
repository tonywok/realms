module Realms
  module Abilities
    class Authority < Ability
      def self.key
        :authority
      end

      def self.auto?
        true
      end

      def execute
        turn.active_player.authority += arg
      end
    end
  end
end
