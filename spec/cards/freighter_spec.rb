require "spec_helper"

RSpec.describe Realms::Cards::Freighter do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :trade_federation
  include_examples "cost", 4

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end
    it { expect { game.play(card) }.to change { game.active_turn.trade }.by(4) }
  end

  describe "#ally_ability" do
    let(:ally_card) {  Realms::Cards::FederationShuttle.new(game.p1) }
    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.play(card)
      game.play(ally_card)
    end

    it {
      game.ally_ability(card)
      trade_row_card = game.trade_deck.trade_row.first
      expect {
        game.acquire(trade_row_card)
      }.to change { game.p1.deck.draw_pile.length }.by(1)

      expect(game.p1.deck.draw_pile.first).to eq(trade_row_card)
      expect(game.p1.deck.discard_pile).to_not include(trade_row_card)

      trade_row_card = game.trade_deck.trade_row.first
      expect {
        game.acquire(trade_row_card)
      }.to change { game.p1.deck.discard_pile.length }.by(1)

      expect(game.p1.deck.discard_pile.first).to eq(trade_row_card)
      expect(game.p1.deck.draw_pile).to_not include(trade_row_card)
    }
  end
end
