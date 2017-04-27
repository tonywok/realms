module Realms
  module Abilities
    class DestroyTargetBase < Ability
      def self.key
        :destroy_target_base
      end

      def execute
        choose(Choice.new(bases_in_play, optional: optional)) do |card|
          player = card.owner
          player.deck.destroy(card)
        end
      end

      def bases_in_play
        all_bases = turn.active_player.deck.battlefield.select(&:base?)
        all_bases.any?(&:outpost?) ? all_bases.select(&:outpost?) : all_bases
      end
    end
  end
end
