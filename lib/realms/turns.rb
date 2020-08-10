require "realms/turns/builder"

module Realms
  module Turns
    def self.structure
      @structure ||= Builder.build do
        phase(:setup) do
          5.times { layout.trade_deck.transfer!(to: layout.trade_row) }
          active_player.draw(3)
          passive_players.each { |p| p.draw(5) }
        end

        loop(:players) do
          phase(:main, actions: [:play, :attack, :acquire, :primary, :scrap, :ally, :end_turn]) do
            choose(eligible_actions) do |action|
              continue = perform(action)
              execute unless continue
            end
          end

          phase(:discard) do
            # TODO: move trade/combat state to layout
            active_turn.trade = 0
            active_turn.combat = 0
            active_player.in_play.select(&:ship?).each do |ship|
              active_player.destroy(ship)
            end
            active_player.hand.each { |card| active_player.discard(card) }
          end

          phase(:draw) do
            active_player.draw(5)
            # active_player.in_play
            # TODO: Probably remove turn as a thing that needs interacted with
          end
        end
      end
    end
  end
end