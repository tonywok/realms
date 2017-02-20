require "spec_helper"

RSpec.describe Realms2::Actions::UsePrimaryAbility do
  let(:game) { Realms2::Game.new }
  let(:card) { Realms2::Cards::BlobWheel.new(game.p1) }
  let(:action) { described_class.new(card) }

  before do
    game.p1.deck.battlefield << card
    game.start
    game.decide(:primary, :blob_wheel_0)
  end

  it do
    expect(game.active_turn.combat).to eq(1)
  end
end
