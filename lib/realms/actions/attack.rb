module Realms
  module Actions
    class Attack < Action
      def self.key
        :attack
      end

      def execute
        choose Choice.new(damageable_targets) do |target|
          case target
          when Realms::Cards::Card
            turn.combat -= target.defense
            passive_player.deck.destroy(target)
          when Realms::Player
            turn.passive_player.authority -= turn.combat
            turn.combat = 0
          end
        end
      end

      def damageable_targets
        eligible = ->(base) { turn.combat >= base.defense }
        outposts, bases = passive_player.deck.battlefield.select(&:base?).partition(&:outpost?)

        if outposts.any?
          outposts.select(&eligible)
        else
          bases.select(&eligible).tap do |targets|
            targets << passive_player if turn.combat.positive?
          end
        end
      end
    end
  end
end
