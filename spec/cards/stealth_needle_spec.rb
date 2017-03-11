require "spec_helper"

RSpec.describe Realms::Cards::StealthNeedle do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#faction" do
    subject { card.faction }
    it { is_expected.to eq(:machine_cult) }
  end

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(4) }
  end

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end

    context "no ships" do
      xit "is just machine cult card with no abilities"
    end

    context "simple ship" do
      xit "becomes a copy of the ship"
    end

    context "complicated ship" do
      xit "becomes a copy of the ship and gains all abilities"
    end
  end
end
