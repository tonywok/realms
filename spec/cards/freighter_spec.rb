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
    let(:selected_card_1) { Realms::Cards::Cutter.new(game.trade_deck, index: 10) }
    let(:selected_card_2) { Realms::Cards::Cutter.new(game.trade_deck, index: 11) }
    let(:ally_card) {  Realms::Cards::FederationShuttle.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.trade_deck.trade_row.cards[0] = selected_card_1
      game.trade_deck.trade_row.cards[4] = selected_card_2
      game.play(card)
      game.play(ally_card)
    end

    it {
      game.ally_ability(card)
      expect {
        game.acquire(selected_card_1)
      }.to change { game.p1.deck.draw_pile.length }.by(1)

      expect(game.p1.deck.draw_pile.first).to eq(selected_card_1)
      expect(game.p1.deck.discard_pile).to_not include(selected_card_1)

      expect {
        game.acquire(selected_card_2)
      }.to change { game.p1.deck.discard_pile.length }.by(1)

      expect(game.p1.deck.discard_pile.first).to eq(selected_card_2)
      expect(game.p1.deck.draw_pile).to_not include(selected_card_2)
    }
  end
end
