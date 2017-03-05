require "spec_helper"

RSpec.describe Realms::Cards::Flagship do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:trade_federation) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(6) }
  end

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end

    it {
      expect {
        game.decide(:play, card.key)
      }.to change { game.active_turn.combat }.by(5).and \
           change { game.p1.deck.draw_pile.length }.by(-1)
    }
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

    it { expect { game.decide(:ally, card.key) }.to change { game.p1.authority }.by(5) }
  end
end
