require "spec_helper"

RSpec.describe Realms::Game do
  it "plays" do
    game = described_class.new.start

    game.play(:scout_0)
    game.play(:scout_1)

    expect(game.active_turn.trade).to eq(2)

    game.acquire(:explorer_0)

    card = game.active_player.deck.discard_pile.first
    expect(card).to be_an_instance_of(Realms::Cards::Explorer)
    expect(game.active_turn.trade).to eq(0)

    game.end_turn
  end
end
