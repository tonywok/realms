module Realms
  module Effects
    class DestroyTargetBase < Effect
      def execute
        choose(bases_in_play) do |card|
          player = card.owner
          player.destroy(card)
        end
      end

      def bases_in_play
        all_bases = turn.active_player.in_play.select(&:base?) +
          turn.passive_player.in_play.select(&:base?)
        all_bases.any?(&:outpost?) ? all_bases.select(&:outpost?) : all_bases
      end
    end
  end
end
