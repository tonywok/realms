module Realms
  module Abilities
    class DestroyTargetBase < Ability
      def execute
        choose(Choice.new(bases_in_play, optional: optional)) do |card|
          player = card.player
          player.deck.destroy(card)
        end
      end

      def bases_in_play
        opponent_bases = turn.active_player.deck.battlefield.select(&:base?)
        own_bases = turn.active_player.deck.battlefield.select(&:base?)
        all_bases = opponent_bases + own_bases
        bases = all_bases.any?(&:outpost?) ? all_bases.select(&:outpost?) : all_bases

        bases.each_with_object({}) do |card, opts|
          opts[card.key] = card
        end
      end
    end
  end
end
