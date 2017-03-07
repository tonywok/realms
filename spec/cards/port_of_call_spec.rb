require "spec_helper"

RSpec.describe Realms::Cards::PortOfCall do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#type" do
    subject { card.type }
    it { is_expected.to eq(:outpost) }
  end

  describe "#type" do
    subject { card.defense }
    it { is_expected.to eq(6) }
  end

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:trade_federation) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(6) }
  end

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.decide(:play, card.key)
    end

    context "authority" do
      it { expect { game.decide(:primary, card.key) }.to change { game.active_turn.trade }.by(3) }
    end
  end

  describe "#scrap_ability" do
    before do
      game.p1.deck.hand << card
    end

    context "base in play" do
      let(:base_card) { Realms::Cards::TradingPost.new(game.p1) }
      before do
        game.p1.deck.battlefield << base_card
        game.start
        game.decide(:play, card.key)
      end

      it {
        expect { game.decide(:scrap, card.key) }.to change { game.p1.deck.hand.length }.by(1)
        game.decide(base_card.key)
        expect(game.p1.deck.discard_pile).to include(base_card)
      }
    end

    context "no base in play" do
      before do
        game.start
        game.decide(:play, card.key)
      end

      it {
        expect {
          game.decide(:scrap, card.key)
        }.to change { game.p1.deck.hand.length }.by(1)
        expect(game.current_choice).to be_an_instance_of(Realms::PlayerAction)
      }
    end
  end
end
