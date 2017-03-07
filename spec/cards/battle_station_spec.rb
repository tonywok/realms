require "spec_helper"

RSpec.describe Realms::Cards::BattleStation do
  let(:game) { Realms::Game.new.start }
  let(:card) { described_class.new(game.p1) }

  describe "#type" do
    subject { card.type }
    it { is_expected.to eq(:outpost) }
  end

  describe "#defense" do
    subject { card.defense }
    it { is_expected.to eq(5) }
  end

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:machine_cult) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(3) }
  end

  describe "#scrap_ability" do
    it { expect { card.scrap_ability.execute }.to change { game.active_turn.combat }.by(5) }
  end
end
