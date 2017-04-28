module Realms
  module Zones
    class InPlay < Zone
      def actions(turn)
        return attack_actions(turn) if owner == turn.passive_player
        base_actions(turn) +
          ally_actions(turn) +
          scrap_actions(turn)
      end

      private

      def base_actions(turn)
        cards.each_with_object([]) do |card, actions|
          if card.base? && turn.activated_base_ability.exclude?(card)
            actions << Actions::BaseAbility.new(turn, card)
          end
        end
      end

      def ally_actions(turn)
        cards.each_with_object([]) do |card, actions|
          if card.ally_ability? && turn.activated_ally_ability.exclude?(card)
            actions << Actions::AllyAbility.new(turn, card)
          end
        end
      end

      def scrap_actions(turn)
        cards.select(&:scrap_ability?).map { |card| Actions::ScrapAbility.new(turn, card) }
      end

      def attack_actions(turn)
        eligible = ->(base) { turn.combat >= base.defense }
        outposts, bases = cards.select(&:base?).partition(&:outpost?)

        if outposts.any?
          outposts.select(&eligible).map { |card| Actions::Attack.new(turn, card) }
        else
          targets = bases.select(&eligible).map { |card| Actions::Attack.new(turn, card) }
          targets << Actions::Attack.new(turn, owner) if turn.combat.positive?
          targets
        end
      end
    end
  end
end
