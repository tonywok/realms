module Realms
  module Abilities
    class TopDeckNextShip < Ability
      def execute
        turn.event_manager.add_observer(self)
      end

      def update(acquire_card)
        acquire_card.zone = :draw_pile
        turn.event_manager.delete_observer(self)
      end
    end
  end

  module Cards
    class Freighter < Card
      faction :trade_federation
      cost 4
      primary_ability Abilities::Trade[4]
      ally_ability Abilities::TopDeckNextShip
    end
  end
end
