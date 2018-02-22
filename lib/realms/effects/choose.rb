module Realms
  module Effects
    class Choose < Effect
      def execute
        choices = effects.map { |e| e.to_effect(card, turn) }
        # TODO: card name probably shouldn't be the subject
        choose(choices, subject: card.name) do  |effect|
          perform effect
        end
      end
    end
  end
end
