require "spec_helper"

RSpec.describe Realms2::Cards::Ram do
  let(:game) { Realms2::Game.new.start }
  let(:card) { described_class.new(game.p1) }

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:blob) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(3) }
  end

  describe "#primary_ability" do
    it { expect { card.primary_ability.execute }.to change { game.active_turn.combat }.by(5) }
  end

  describe "#ally_ability" do
    it { expect { card.ally_ability.execute }.to change { game.active_turn.combat }.by(2) }
  end

  describe "#scrap_ability" do
    it { expect { card.scrap_ability.execute }.to change { game.active_turn.trade }.by(3) }
  end
end
