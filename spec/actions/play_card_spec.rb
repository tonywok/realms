require "spec_helper"

RSpec.describe Realms::Actions::PlayCard do
  let(:game) { Realms::Game.new }
  let(:card1) { Realms::Cards::Scout.new(game.p1, index: 10) }
  let(:card2) { Realms::Cards::Scout.new(game.p1, index: 11) }
  let(:card3) { Realms::Cards::Scout.new(game.p1, index: 12) }

  before do
    game.p1.deck.hand << card1
    game.p1.deck.hand << card2
    game.p1.deck.hand << card3
    game.start
  end

  it do
    expect {
      game.play(:scout_10)
    }.to change { game.active_player.deck.hand.length }.by(-1).and \
         change { game.active_player.deck.in_play.length }.by(1)
    game.play(:scout_11)
    game.play(:scout_12)
    expect(game.active_turn.trade).to eq(3)
  end
end
