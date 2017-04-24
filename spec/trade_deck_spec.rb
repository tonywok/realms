require "spec_helper"

RSpec.describe Realms::TradeDeck do
  let(:game) { Realms::Game.new }
  let(:trade_deck) { game.trade_deck }

  describe "with a seed" do
    let(:seed) { Random.new_seed }

    it "generates the same trade row" do
      g1 = Realms::Game.new(seed)
      10.times.map do
        gn = Realms::Game.new(seed)
        cards = gn.trade_deck.trade_row.cards

        expect(g1.seed).to eq(gn.seed)
        expect(cards).to eq(g1.trade_deck.trade_row.cards)
      end
    end
  end

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
