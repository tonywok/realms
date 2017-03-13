shared_examples "destroy_target_base" do
  context "no bases in play" do
    def setup(game)
      game.p1.deck.hand << card
    end

    it "has no eligible attack.<base> targets" do
      attack_targets = game.current_choice.options.except("attack.#{game.p2.name}").keys.select { |key| key =~ /attack/ }
      expect(attack_targets).to be_empty
    end
  end

  context "base in play" do
    let(:base_card) { Realms::Cards::BlobWheel.new(game.p1) }

    def setup(game)
      game.p1.deck.battlefield << base_card
      game.p1.deck.hand << card
    end

    it {
      game.decide(base_card.key)
      expect(game.p1.deck.discard_pile).to include(base_card)
    }
  end

  context "both outpost and base in play" do
    let(:base_card) { Realms::Cards::BlobWheel.new(game.p1) }
    let(:outpost_card) { Realms::Cards::BattleStation.new(game.p1) }

    def setup(game)
      game.p1.deck.battlefield << base_card
      game.p1.deck.battlefield << outpost_card
      game.p1.deck.hand << card
    end

    it "must choose the outpost card first" do
      expect(game.current_choice.options).to have_value(outpost_card)
      expect(game.current_choice.options).to_not have_value(base_card)
      game.decide(outpost_card.key)
      expect(game.p1.deck.discard_pile).to include(outpost_card)
    end
  end
end

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
