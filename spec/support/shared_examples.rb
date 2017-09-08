shared_examples "destroy_target_base" do
  def setup; end

  before do
    setup
  end

  context "no bases in play" do
    it "has no eligible attack.<base> targets" do
      attack_targets = game.current_choice.options.except(:"attack.#{game.passive_player.key}").keys.select { |key| key =~ /attack/ }
      expect(attack_targets).to be_empty
    end
  end

  context "base in play" do
    let(:base_card) { Realms::Cards::BarterWorld.new(game.p1) }

    def setup
      game.p1.in_play << base_card
    end

    it {
      game.decide(:destroy_target_base, base_card)
      expect(game.active_player.discard_pile).to include(base_card)
    }
  end

  context "both outpost and base in play" do
    let(:base_card) { Realms::Cards::BarterWorld.new(game.p1) }
    let(:outpost_card) { Realms::Cards::BattleStation.new(game.p1) }

    def setup
      game.p1.in_play << base_card
      game.p1.in_play << outpost_card
    end

    it "must choose the outpost card first" do
      expect(game.current_choice.options).to have_key(:"destroy_target_base.#{outpost_card.key}")
      expect(game.current_choice.options).to_not have_key(:"destroy_target_base.#{base_card.key}")
      game.decide(:destroy_target_base, outpost_card)
      expect(game.active_player.discard_pile).to include(outpost_card)
    end
  end
end

shared_examples "scrap_card_from_hand_or_discard_pile" do
  let(:game) { Realms::Game.new }
  let(:discarded_card) { Realms::Cards::Scout.new(game.p1, index: 42) }

  before do
    game.p1.discard_pile << discarded_card
  end

  context "opting out of the scrap" do
    it {
      expect {
        game.decide(:"scrap_from_hand_or_discard_pile.none")
      }.to change { game.trade_deck.scrap_heap.length }.by(0)
    }
  end

  context "scrapping from hand" do
    let(:card_in_hand) { game.p1.hand.first }
    it {
      game.decide(:"scrap_from_hand_or_discard_pile.#{card_in_hand.key}")
      expect(game.trade_deck.scrap_heap).to include(card_in_hand)
    }
  end

  context "scrapping from discard pile" do
    it {
      game.decide(:"scrap_from_hand_or_discard_pile.#{discarded_card.key}")
      expect(game.trade_deck.scrap_heap).to include(discarded_card)
    }
  end
end

shared_examples "factions" do |factions|
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }
  describe "#factions" do
    subject { card.factions }
    it { is_expected.to contain_exactly(*factions) }
  end
end

shared_examples "cost" do |cost|
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }
  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(cost) }
  end
end

shared_examples "type" do |type|
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }
  describe "#type" do
    subject { card.type }
    it { is_expected.to eq(type) }
  end
end

shared_examples "defense" do |defense|
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }
  describe "#defense" do
    subject { card.defense }
    it { is_expected.to eq(defense) }
  end
end

RSpec.shared_context "primary_ability" do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1, index: 42) }

  before do
    game.p1.hand << card
    game.start
  end
end

RSpec.shared_context "base_ability" do
  include_context "primary_ability"

  before do
    game.play(card)
  end
end

RSpec.shared_context "scrap_ability" do
  include_context "primary_ability"

  before do
    game.play(card)
  end
end

RSpec.shared_context "ally_ability" do |ally_card_klass|
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1, index: 42) }
  let(:ally) { ally_card_klass.new(game.p1, index: 43) }

  before do
    game.p1.hand << card
    game.p1.hand << ally
    game.start
    game.play(ally)
    game.play(card)
  end
end

RSpec.shared_context "automatic_ally_ability" do |ally_card_klass|
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1, index: 42) }
  let(:ally) { ally_card_klass.new(game.p1, index: 43) }

  before do
    game.p1.hand << card
    game.p1.hand << ally
    game.start
    game.play(ally)
  end
end
