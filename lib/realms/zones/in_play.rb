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
        card = event.args.first.card
        add_card(card)

        # TODO: is this a class?
        cards_in_play.each do |card_state|
          card_state.refresh!
        end

        card.events.attach(self)
      end

      def on_card_removed(event)
        card = event.args.first.card
        @in_play.delete(card.key)
        card.events.detach(self)
      end

      def on_ally_ability(event)
        card = event.args.first
        card_state(card).ally.exhaust!
      end

      def on_primary_ability(event)
        card = event.args.first
        card_state(card).primary.exhaust!
      end

      def on_definition_change(_)
        cards_in_play.each(&:refresh!)
      end

      def actions
        if my_turn?
          my_actions
        else
          your_actions
        end
      end

      def cards_in_play
        in_play.values
      end

      def reset!
        cards_in_play.each(&:reset!)
      end

      private

      def card_state(card)
        @in_play.fetch(card.key)
      end

      def my_turn?
        active_turn.active_player == owner
      end

      def my_actions
        cards_in_play.flat_map do |card_state|
          card_state.actions(active_turn)
        end
      end

      def your_actions
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

      def add_card(card)
        @in_play[card.key] = CardState.new(card)
      end
    end
  end
end
