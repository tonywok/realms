require "spec_helper"

RSpec.describe Realms::Actions::ScrapAbility do
  let(:game) { Realms::Game.new }
  let(:card) { Realms::Cards::Explorer.new(game.active_player) }
  let(:action) { described_class.new(card) }

  before do
    game.p1.in_play << card
    game.start
    game.scrap_ability(card)
  end

  it do
    expect(card.owner).to eq(game.trade_deck)
    expect(card.zone).to eq(game.trade_deck.scrap_heap)
    expect(game.active_turn.combat).to eq(2)
  end
end
