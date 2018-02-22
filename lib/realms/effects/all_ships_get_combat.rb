module Realms
  module Effects
    class AllShipsGetCombat < Effect
      def self.auto?
        true
      end

      def execute
        card.owner.in_play.events.attach(self)
      end

      def on_card_added(event)
        played_card = event.args.first.card
        if played_card.ship?
          played_card.definition = played_card.definition.dup.tap do |defn|
            defn.primary_ability.effects << Definitions::Numeric.new(Combat, 1)
          end
        end
      end

      def on_card_removed(event)
        card.owner.in_play.events.detach(self)
      end
    end
  end
end
