require "spec_helper"

RSpec.describe Realms2::Actions::PlayCard do
  let(:game) { Realms2::Game.new }
  let(:card1) { Realms2::Cards::Scout.new(game.p1) }
  let(:card2) { Realms2::Cards::Scout.new(game.p1) }
  let(:card3) { Realms2::Cards::Scout.new(game.p1) }

  before do
    game.p1.deck.hand << card1
    game.p1.deck.hand << card2
    game.p1.deck.hand << card3
    game.start
  end

  it do
    expect {
      game.decide(:play, :scout_0)
    }.to change { game.active_player.deck.hand.length }.by(-1).and \
         change { game.active_player.deck.battlefield.length }.by(1)
    game.decide(:play, :scout_1)
    game.decide(:play, :scout_2)
    expect(game.active_turn.trade).to eq(3)
  end
end
