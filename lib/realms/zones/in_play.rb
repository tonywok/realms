module Realms
  module Zones
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

          if (cards - [card]).any? { |cip| (cip.ally_factions & card.ally_factions).present? }
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

    class CardInPlay
      attr_reader :card
      attr_accessor :ally_activated, :base_activated, :played_this_turn

      delegate_missing_to :card

      def initialize(card)
        @card = card
        reset!(true)
      end

      def ally_activated?
        ally_ability? && ally_activated
      end

      def base_activated?
        base? && base_activated
      end

      def played_this_turn?
        played_this_turn
      end

      def ally_ability
        super.tap { self.ally_activated = false }
      end

      def primary_ability
        super.tap { self.base_activated = false }
      end

      def reset!(first_time = false)
        self.ally_activated = true
        self.base_activated = true
        self.played_this_turn = first_time
      end
    end
  end
end
