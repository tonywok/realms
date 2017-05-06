require "spec_helper"

RSpec.describe Realms::Actions::BaseAbility do
  let(:game) { Realms::Game.new }
  let(:card) { Realms::Cards::BlobWheel.new(game.p1) }
  let(:action) { described_class.new(card) }

  before do
    game.p1.deck.in_play << card
    game.start
    game.base_ability(card)
  end

  it do
    expect(game.active_turn.combat).to eq(1)
    expect { game.base_ability(card) }.to raise_error(Realms::Choice::InvalidOption)
  end
end
