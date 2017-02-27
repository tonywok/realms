require "spec_helper"

RSpec.describe Realms::Cards::BattleBlob do
  let(:game) { Realms::Game.new.start }
  let(:card) { described_class.new(game.p1) }

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:blob) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(6) }
  end

  describe "#primary_ability" do
    before { card.primary_ability.execute }
    it { expect(game.active_turn.combat).to eq(8) }
  end

  describe "#ally_ability" do
    it { expect { card.ally_ability.execute }.to change { game.p1.deck.hand.length }.by(1) }
  end

  describe "#scrap_ability" do
    it { expect { card.scrap_ability.execute }.to change { game.active_turn.combat }.by(4) }
  end
end
