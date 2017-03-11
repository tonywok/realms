shared_examples "scrap_card_from_hand_or_discard_pile" do
  context "opting out of the scrap" do
    it {
      expect { game.decide(:none) }.to change { game.trade_deck.scrap_heap.length }.by(0)
    }
  end

  context "scrapping from hand" do
    let(:card_in_hand) { game.p1.deck.hand.first }
    it {
      game.decide(card_in_hand.key)
      expect(game.trade_deck.scrap_heap).to include(card_in_hand)
    }
  end

  context "scrapping from discard pile" do
    let(:discarded_card) { game.p1.deck.discard_pile.first }
    it {
      game.decide(discarded_card.key)
      expect(game.trade_deck.scrap_heap).to include(discarded_card)
    }
  end
end
