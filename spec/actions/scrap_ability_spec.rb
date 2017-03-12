require "spec_helper"

RSpec.describe Realms::Actions::ScrapAbility do
  let(:game) { Realms::Game.new }
  let(:card) { Realms::Cards::Explorer.new(game.p1) }
  let(:action) { described_class.new(card) }

  before do
    game.p1.deck.battlefield << card
    game.start
    game.scrap_ability(:explorer_0)
  end

  it do
    expect(card.player).to eq(Realms::Player::Unclaimed.instance)
    expect(game.p1.deck).to_not include(card)
    expect(game.active_turn.combat).to eq(2)
  end
end
