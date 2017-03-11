require "spec_helper"

RSpec.describe Realms::Cards::BattleMech do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:machine_cult) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(5) }
  end

  describe "#primary_ability" do
    let(:another_card) { Realms::Cards::Scout.new(game.p1, index: 42) }
    before do
      game.p1.deck.hand << card
      game.p1.deck.discard_pile << another_card
      game.start
      expect { game.decide(:play, card.key) }.to change { game.active_turn.combat }.by(4)
    end

    include_examples "scrap_card_from_hand_or_discard_pile"
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::BattleStation.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.decide(:play, ally_card.key)
      game.decide(:play, card.key)
      game.decide(:none)
    end

    it { expect { game.decide(:ally, card.key) }.to change { game.p1.deck.hand.length }.by(1) }
  end
end
