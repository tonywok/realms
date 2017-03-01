require "spec_helper"

RSpec.describe Realms::Cards::Cutter do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:trade_federation) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(2) }
  end

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end

    it {
      expect {
        game.decide(:play, :cutter_0)
      }.to change { game.active_turn.trade }.by(2).and \
           change { game.p1.authority }.by(4)
    }
  end

  describe "#ally_ability" do
    before { game.start }
    it { expect { card.ally_ability.execute }.to change { game.active_turn.combat }.by(4) }
  end
end
