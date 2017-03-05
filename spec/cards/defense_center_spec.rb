require "spec_helper"

RSpec.describe Realms::Cards::DefenseCenter do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#type" do
    subject { card.type }
    it { is_expected.to eq(:outpost) }
  end

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:trade_federation) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(5) }
  end

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.decide(:play, card.key)
      game.decide(:primary, card.key)
    end

    context "authority" do
      it { expect { game.decide(:option_0) }.to change { game.p1.authority }.by(3) }
    end

    context "trade" do
      it { expect { game.decide(:option_1) }.to change { game.active_turn.combat }.by(2) }
    end
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::FederationShuttle.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.decide(:play, card.key)
      game.decide(:play, ally_card.key)
    end

    it { expect { game.decide(:ally, card.key) }.to change { game.active_turn.combat }.by(2) }
  end
end

