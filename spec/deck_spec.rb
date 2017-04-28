require "spec_helper"

RSpec.describe Realms::Deck do
  let(:game) { Realms::Game.new }
  let(:deck) { described_class.new(game.p1) }

  describe "#cards" do
    subject { deck.draw_pile.map(&:key) }
    it do
      is_expected.to contain_exactly(
        :scout_0,
        :scout_1,
        :scout_2,
        :scout_3,
        :scout_4,
        :scout_5,
        :scout_6,
        :scout_7,
        :viper_0,
        :viper_1,
      )
    end
  end

  describe "#discard" do
    it "takes a card from the hand and puts it in the discard pile" do
      deck.draw
      expect {
        deck.discard(deck.hand.sample)
      }.to change { deck.hand.length }.by(-1).and \
           change { deck.discard_pile.length }.by(1)
    end

    context "when given a card not in the hand" do
      let(:card) { Realms::Cards::Cutter.new(game.p1) }
      it { expect { deck.discard(card) }.to raise_error(Realms::InvalidTarget) }
    end
  end

  describe "#discard_hand" do
    it "takes a card from the hand and puts it in the discard pile" do
      5.times { deck.draw }
      expect(deck.hand.length).to eq(5)
      expect(deck.draw_pile.length).to eq(5)
      deck.discard_hand
      expect(deck.hand.length).to eq(0)
      expect(deck.draw_pile.length).to eq(5)
      expect(deck.discard_pile.length).to eq(5)
    end
  end

  describe "#draw" do
    it "takes a card from the draw pile and puts it in the hand" do
      expect {
        deck.draw
      }.to change { deck.draw_pile.length }.by(-1).and \
           change { deck.hand.length }.by(1)
    end

    context "triggering a reshuffle" do
      it "uses the discard pile" do
        10.times { deck.draw }

        expect(deck.hand.length).to eq(10)
        expect(deck.draw_pile.length).to eq(0)
        expect(deck.discard_pile.length).to eq(0)

        deck.discard_hand
        deck.draw

        expect(deck.hand.length).to eq(1)
        expect(deck.draw_pile.length).to eq(9)
        expect(deck.discard_pile.length).to eq(0)
      end
    end

    context "when out of cards" do
      it "does nothing" do
        10.times { deck.draw }
        expect(deck.draw_pile.length).to eq(0)
        expect { deck.draw }.to change { deck.hand.length }.by(0).and \
                                change { deck.draw_pile.length }.by(0).and \
                                change { deck.discard_pile.length }.by(0).and \
                                change { deck.in_play.length }.by(0)
      end
    end
  end

  describe "#play" do
    it "moves a card from the hand to the in_play" do
      5.times { deck.draw }
      expect { deck.play(deck.hand.first) }.to change { deck.hand.length }.by(-1).and \
                                               change { deck.in_play.length }.by(1)
    end

    context "when given a card not in the hand" do
      let(:card) { Realms::Cards::Cutter.new(game.p1) }
      it { expect { deck.play(card) }.to raise_error(Realms::InvalidTarget) }
    end
  end
end
