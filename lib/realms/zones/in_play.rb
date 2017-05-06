module Realms
  module Zones
    class CardInPlay
      attr_reader :card
      attr_accessor :ally_activated, :base_activated

      delegate_missing_to :card

      def initialize(card)
        @card = card
        reset!
      end

      def ally_activated?
        ally_ability? && ally_activated
      end

      def base_activated?
        base? && base_activated
      end

      def ally_ability
        super.tap { self.ally_activated = false }
      end

      def base_ability
        super.tap { self.base_actviated = false }
      end

      private

      def reset!
        self.ally_activated = true
        self.base_activated = true
      end
    end

    class InPlay < Zone
      def insert(pos, card)
        super(pos, CardInPlay.new(card))
      end

      def <<(card)
        super(CardInPlay.new(card))
      end

      def include?(card)
        cards.include?(card) || cards.map(&:card).include?(card)
      end

      def remove(card)
        super.card
      end

      def actions
        return attack_actions if owner == active_turn.passive_player
        base_actions + ally_actions + scrap_actions
      end

      private

      def base_actions
        cards.select(&:base_activated?).map { |card| Actions::BaseAbility.new(active_turn, card) }
      end

      def ally_actions
        cards.each_with_object([]) do |card, actions|
          next unless card.ally_activated?

          if (cards - [card]).any? { |cip| (cip.factions & card.factions).present? }
            actions << Actions::AllyAbility.new(active_turn, card)
          end
        end
      end

      def scrap_actions
        cards.select(&:scrap_ability?).map { |card| Actions::ScrapAbility.new(active_turn, card) }
      end

      def attack_actions
        eligible = ->(base) { active_turn.combat >= base.defense }
        outposts, bases = cards.select(&:base?).partition(&:outpost?)

        if outposts.any?
          outposts.select(&eligible).map { |card| Actions::Attack.new(active_turn, card) }
        else
          targets = bases.select(&eligible).map { |card| Actions::Attack.new(active_turn, card) }
          targets << Actions::Attack.new(active_turn, owner) if active_turn.combat.positive?
          targets
        end
      end
    end
  end
end
