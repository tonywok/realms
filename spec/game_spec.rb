require "spec_helper"

RSpec.describe Realms::Game do
  it "plays" do
    game = described_class.new.start
    game.decide(:play, :scout_0)
    game.decide(:play, :scout_1)
    expect(game.active_turn.trade).to eq(2)
    game.decide(:acquire, :explorer)
    card = game.active_player.deck.discard_pile.first
    expect(card).to be_an_instance_of(Realms::Cards::Explorer)
    expect(game.active_turn.trade).to eq(0)
    game.decide(:end_turn)
  end
end
