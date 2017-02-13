require "spec_helper"

RSpec.describe Realms2::Actions::UseScrapAbility do
  let(:game) { Realms2::Game.new }
  let(:card) { Realms2::Cards::Explorer.new(game.p1) }
  let(:action) { described_class.new(card) }

  before do
    game.p1.deck.battlefield << card
    game.start
    game.decide(:scrap, :explorer)
  end

  it do
    expect(card.player).to eq(Realms2::Player::Unclaimed.instance)
    expect(game.p1.deck).to_not include(card)
    expect(game.active_turn.combat).to eq(2)
    expect(game.active_turn.combat).to eq(2)
  end
end
