module Realms
  module Effects
    class TopDeckNextShip < Effect
      def execute
        trade_deck.trade_row.events.attach(self)
      end

      def on_removing_card(event)
        zt = event.args.first
        if zt.card.ship?
          zt.destination = active_player.draw_pile
          zt.destination_position = 0
          trade_deck.trade_row.events.detach(self)
        end
      end
    end
  end
end
