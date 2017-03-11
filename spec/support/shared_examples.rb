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

shared_examples "factions" do |factions|
  describe "#factions" do
    subject { card.factions }
    it { is_expected.to contain_exactly(*factions) }
  end
end

shared_examples "cost" do |cost|
  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(cost) }
  end
end

shared_examples "type" do |type|
  describe "#type" do
    subject { card.type }
    it { is_expected.to eq(type) }
  end
end

shared_examples "defense" do |defense|
  describe "#type" do
    subject { card.defense }
    it { is_expected.to eq(defense) }
  end
end
