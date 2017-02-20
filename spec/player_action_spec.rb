require "spec_helper"

RSpec.describe Realms::PlayerAction do
  let(:game) { Realms::Game.new.start }

  context "when multiple cards by the same name" do
    it "identifies them uniquely" do
      game.active_turn.active_player.deck.hand.each do |card|
        game.decide(:play, card.key)
      end
    end
  end
end
