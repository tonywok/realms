require "spec_helper"

RSpec.describe Realms::TradeDeck do
  let(:game) { Realms::Game.new }
  let(:trade_deck) { game.trade_deck }

  describe "#scrap" do
    it "removes a card from the trade row and replaces it with a card from the draw pile" do
      card = trade_deck.trade_row.first
      new_card = trade_deck.draw_pile.first
      expect { trade_deck.scrap(card) }.to change { trade_deck.draw_pile.length }.by(-1)
      expect(trade_deck.trade_row).to include(new_card)
      expect(trade_deck.trade_row.cards.index(new_card)).to eq(0)
    end
  end
end
