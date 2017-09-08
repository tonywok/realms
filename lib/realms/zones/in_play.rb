require "realms/zones/in_play/card_state"

module Realms
  module Zones
    class InPlay < Zone
      attr_reader :in_play

      def initialize(*args)
        super
        @cards = []
        @in_play = {}
      end

      def on_card_added(event)
        add_card(event.args.first.card)
      end

      def on_card_removed(event)
        @in_play.delete(event.args.first.card.key)
      end

      def actions
        return attack_actions if owner == active_turn.passive_player
        base_actions + ally_actions + scrap_actions
      end

      def execute
        cards_in_play.each do |card|
          perform(card.primary_ability(active_turn)) if card.auto_primary_available?
          perform(card.ally_ability(active_turn)) if auto_ally_available?(card)
        end
      end

      def cards_in_play
        in_play.values
      end

      def reset!(card)
        card_in_play = in_play.fetch(card.key)
        card_in_play.reset!
      end

      private

      def add_card(card)
        @in_play[card.key] = CardState.new(card)
      end

      def base_actions
        cards_in_play.select(&:primary_available?).map { |card| Actions::BaseAbility.new(active_turn, card) }
      end

      def ally_actions
        cards_in_play.each_with_object([]) do |card, actions|
          actions << Actions::AllyAbility.new(active_turn, card) if ally_available?(card)
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

      def ally_available?(card)
        return false unless card.ally_ability?
        return false if card.ally_used
        in_play.except(card.key).values.any? { |other| card.ally?(other) }
      end

      def auto_ally_available?(card)
        card.automatic_ally_ability? && ally_available?(card)
      end
    end
  end
end
