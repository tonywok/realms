module Realms
  module Phases
    class Main < Phase
      delegate :active_player, :passive_player,
        to: :turn

      def execute
        choose Choice.new(player_actions) do |decision|
          perform decision
          execute unless decision.is_a?(Realms::Actions::EndMainPhase)
        end
      end

      def player_actions
        {
          Actions::PlayCard => cards_in_hand,
          Actions::BaseAbility => unused_bases,
          Actions::AllyAbility => unused_allies,
          Actions::ScrapAbility => unused_scrap,
          Actions::AcquireCard => purchasable_cards,
          Actions::Attack => attackable_targets,
        }.flat_map do |action_klass, targets|
          targets.map do |target|
            action_klass.new(turn, target)
          end
        end + [Actions::EndMainPhase.new(turn)]
      end

      private

      def cards_in_hand
        active_player.deck.hand
      end

      def unused_bases
        active_player.deck.battlefield.select do |card|
          card.base? && turn.activated_base_ability.exclude?(card)
        end
      end

      def unused_allies
        active_player.deck.battlefield.select do |card|
          card.ally_ability? && turn.activated_ally_ability.exclude?(card)
        end
      end

      def unused_scrap
        active_player.deck.battlefield.select(&:scrap_ability?)
      end

      def purchasable_cards
        cards = turn.trade_deck.trade_row + [turn.trade_deck.explorers.first]
        cards.select { |card| turn.trade >= card.cost }
      end

      def attackable_targets
        eligible = ->(base) { turn.combat >= base.defense }
        outposts, bases = passive_player.deck.battlefield.select(&:base?).partition(&:outpost?)

        if outposts.any?
          outposts.select(&eligible)
        else
          targets = bases.select(&eligible)
          targets << passive_player if turn.combat.positive?
          targets
        end
      end
    end
  end
end
