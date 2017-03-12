module Realms
  module Abilities
    class AcquireShipAndTopDeck < Ability
      def self.key
        :acquire_ship_and_top_deck
      end

      def execute
        choose(Choice.new(trade_row_ships, optional: optional)) do |card|
          # TODO: Make this less awkward. Who's responsible for ownership transfer?
          selected_card = turn.trade_deck.acquire(card)
          turn.active_player.deck.draw_pile.unshift(selected_card)
        end
      end

      def trade_row_ships
        turn.trade_deck.trade_row.select(&:ship?)
      end
    end
  end
end
