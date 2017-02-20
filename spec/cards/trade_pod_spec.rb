require "spec_helper"

RSpec.describe Realms2::Cards::TradePod do
  let(:game) { Realms2::Game.new.start }
  let(:card) { described_class.new(game.p1) }

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(2) }
  end

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:blob) }
  end

  describe "#primary_ability" do
    before { card.primary_ability.execute }
    it { expect(game.active_turn.trade).to eq(3) }
  end

  describe "#ally_ability" do
    it { expect { card.ally_ability.execute }.to change { game.active_turn.combat }.by(2) }
  end
end
