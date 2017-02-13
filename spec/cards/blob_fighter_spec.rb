require "spec_helper"

RSpec.describe Realms2::Cards::BlobFighter do
  let(:game) { Realms2::Game.new.start }
  let(:card) { described_class.new(game.p1) }

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(1) }
  end

  describe "#primary_ability" do
    before { card.primary_ability.execute }
    it { expect(game.active_turn.combat).to eq(3) }
  end

  describe "#ally_ability" do
    it { expect { card.ally_ability.execute }.to change(card.player.deck.hand, :length).by(1) }
  end
end
