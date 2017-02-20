require "spec_helper"

RSpec.describe Realms2::PlayerAction do
  let(:game) { Realms2::Game.new.start }

  context "when multiple cards by the same name" do
    it "identifies them uniquely" do
      game.active_turn.active_player.deck.hand.each do |card|
        game.decide(:play, card.key)
      end
    end
  end
end
