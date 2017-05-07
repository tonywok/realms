require "spec_helper"

RSpec.describe Realms::Cards::Freighter do
  include_examples "factions", :trade_federation
  include_examples "cost", 4

  describe "#primary_ability" do
    include_context "primary_ability"
    it { expect { game.play(card) }.to change { game.active_turn.trade }.by(4) }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::FederationShuttle do
      let(:selected_card_1) { Realms::Cards::Cutter.new(game.trade_deck, index: 10) }
      let(:selected_card_2) { Realms::Cards::Cutter.new(game.trade_deck, index: 11) }

      before do
        game.trade_deck.trade_row.cards[0] = selected_card_1
        game.trade_deck.trade_row.cards[4] = selected_card_2
      end
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
