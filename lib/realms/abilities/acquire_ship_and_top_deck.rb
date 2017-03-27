module Realms
  module Abilities
    class AcquireShipAndTopDeck < Ability
      def self.key
        :acquire_ship_and_top_deck
      end

      def execute
        choose(Choice.new(trade_row_ships, optional: optional)) do |card|
          zt = ZoneTransfer.new(card: card, source: turn.trade_deck.trade_row, destination: active_player.draw_pile)
          zt.transfer!(0)
        end
      end

      def trade_row_ships
        turn.trade_deck.trade_row.select(&:ship?)
      end
    end
  end
end
