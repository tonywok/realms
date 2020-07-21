require "realms/turns/builder"

module Realms
  module Turns
    def self.structure
      @structure ||= Builder.build do
        phase(:setup) do
          trade_deck.setup
          active_player.draw(3)
          passive_player.draw(5)
        end

        loop(:players) do
          phase(:main) do
            # TODO: probabaly move to layout
            actions = active_player.actions +
                      passive_player.in_play.actions +
                      trade_deck.actions +
                      [Actions::EndMainPhase.new(active_turn)]
            choose(actions) do |action|
              perform(action)
              execute unless action.is_a?(Actions::EndMainPhase)
            end
          end

          phase(:discard) do
            # TODO: move trade/combat state to layout
            active_turn.trade = 0
            active_turn.combat = 0
            active_player.in_play.select(&:ship?).each do |ship|
              active_player.destroy(ship)
            end
            active_player.discard_hand
          end

          phase(:draw) do
            active_player.draw(5)
            active_player.in_play.reset!
            # TODO: Probably remove turn as a thing that needs interacted with
            game.send(:next_turn)
          end
        end
      end
    end
  end
end