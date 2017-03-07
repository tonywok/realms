require "spec_helper"

RSpec.describe Realms::Cards::CentralOffice do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#type" do
    subject { card.type }
    it { is_expected.to eq(:base) }
  end

  describe "#defense" do
    subject { card.defense }
    it { is_expected.to eq(6) }
  end

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:trade_federation) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(7) }
  end

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.decide(:play, card.key)
    end

    it {
      expect {
        game.decide(:primary, card.key)
      }.to change { game.active_turn.trade }.by(2)
      trade_row_card = game.trade_deck.trade_row.first
      expect {
        game.decide(:acquire, trade_row_card.key)
      }.to change { game.p1.deck.draw_pile.length }.by(1)
    }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::FederationShuttle.new(game.p1) }

    before do
      game.p1.deck.hand << ally_card
      game.p1.deck.hand << card
      game.start
      game.decide(:play, card.key)
    end

    it {
      expect { game.decide(:primary, card.key) }.to change { game.active_turn.trade }.by(2)
      trade_row_card = game.trade_deck.trade_row.first
      expect {
        game.decide(:acquire, trade_row_card.key)
      }.to change { game.p1.deck.draw_pile.length }.by(1)
      expect(game.p1.deck.hand).to_not include(trade_row_card)
      game.decide(:play, ally_card.key)
      game.decide(:ally, card.key)
      expect(game.p1.deck.hand).to include(trade_row_card)
    }
  end
end
