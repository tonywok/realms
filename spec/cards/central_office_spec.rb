require "spec_helper"

RSpec.describe Realms::Cards::CentralOffice do
  include_examples "type", :base
  include_examples "defense", 6
  include_examples "factions", :trade_federation
  include_examples "cost", 7

  describe "#primary_ability" do
    include_context "primary_ability" do
      let(:selected_card) { Realms::Cards::Cutter.new(index: 10) }
      before do
        game.trade_deck.trade_row.cards[0] = selected_card
      end
    end

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.trade }.by(2)
      trade_row_card = game.trade_deck.trade_row.first
      expect {
        game.acquire(trade_row_card)
      }.to change { game.p1.deck.draw_pile.length }.by(1)
    }
  end

  describe "#ally_ability" do
    include_context "primary_ability" do
      let(:selected_card) { Realms::Cards::Cutter.new(index: 10) }
      let(:ally_card) { Realms::Cards::FederationShuttle.new(game.p1) }

      before do
        game.p1.hand << ally_card
        game.trade_deck.trade_row.cards[0] = selected_card
      end
    end

    it {
      expect { game.play(card) }.to change { game.active_turn.trade }.by(2)
      trade_row_card = game.trade_deck.trade_row.first
      expect {
        game.acquire(trade_row_card)
      }.to change { game.p1.deck.draw_pile.length }.by(1)
      expect(game.p1.deck.hand).to_not include(trade_row_card)
      game.play(ally_card)
      game.ally_ability(card)
      expect(game.p1.deck.hand).to include(trade_row_card)
    }
  end
end
