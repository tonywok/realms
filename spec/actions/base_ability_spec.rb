require "spec_helper"

RSpec.describe Realms::Actions::BaseAbility do
  let(:game) { Realms::Game.new }
  let(:card) { Realms::Cards::BlobWheel.new(game.p1) }
  let(:action) { described_class.new(card) }

  before do
    game.p1.deck.battlefield << card
    game.start
    game.base_ability(:blob_wheel_0)
  end

  it do
    expect(game.active_turn.combat).to eq(1)
    expect { game.base_ability(:blob_wheel_0) }.to raise_error(Realms::Choice::InvalidOption)
  end
end
