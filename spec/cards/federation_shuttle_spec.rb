require "spec_helper"

RSpec.describe Realms::Cards::FederationShuttle do
  let(:game) { Realms::Game.new.start }
  let(:card) { described_class.new(game.p1) }

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:trade_federation) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(1) }
  end

  describe "#primary_ability" do
    before { card.primary_ability.execute }
    it { expect(game.active_turn.trade).to eq(2) }
  end

  describe "#ally_ability" do
    it { expect { card.ally_ability.execute }.to change { game.p1.authority }.by(4) }
  end
end