module Realms
  module Zones
    class DiscardPile < Zone
      def on_card_added(event)
        zt = event.args.first
        zt.card.definition = zt.card.class.definition
      end
    end
  end
end
