require "spec_helper"

RSpec.describe Realms::Cards::CommandShip do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:trade_federation) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(8) }
  end

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end

    it {
      expect {
        game.decide(:play, card.key)
      }.to change { game.p1.authority }.by(4).and \
           change { game.p1.active_turn.combat }.by(5).and \
           change { game.p1.deck.draw_pile.length }.by(-2)
    }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::FederationShuttle.new(game.p1) }
    let(:base_card) { Realms::Cards::TradingPost.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.p1.deck.battlefield << base_card
      game.start
      game.decide(:play, ally_card.key)
      game.decide(:play, card.key)
    end

    it {
      game.decide(:ally, card.key)
      game.decide(base_card.key)
      expect(game.p1.deck.discard_pile).to include(base_card)
    }
  end
end
