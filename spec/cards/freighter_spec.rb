require "spec_helper"

RSpec.describe Realms::Cards::Freighter do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:trade_federation) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(4) }
  end

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end
    it { expect { game.decide(:play, card.key) }.to change { game.active_turn.trade }.by(4) }
  end

  describe "#ally_ability" do
    let(:ally_card) {  Realms::Cards::FederationShuttle.new(game.p1) }
    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.decide(:play, card.key)
      game.decide(:play, ally_card.key)
    end

    it {
      game.decide(:ally, card.key)
      trade_row_card = game.trade_deck.trade_row.first
      expect {
        game.decide(:acquire, trade_row_card.key)
      }.to change { game.p1.deck.draw_pile.length }.by(1)

      expect(game.p1.deck.draw_pile.first).to eq(trade_row_card)
      expect(game.p1.deck.discard_pile).to_not include(trade_row_card)

      trade_row_card = game.trade_deck.trade_row.first
      expect {
        game.decide(:acquire, trade_row_card.key)
      }.to change { game.p1.deck.discard_pile.length }.by(1)

      expect(game.p1.deck.discard_pile.first).to eq(trade_row_card)
      expect(game.p1.deck.draw_pile).to_not include(trade_row_card)
    }
  end
end
