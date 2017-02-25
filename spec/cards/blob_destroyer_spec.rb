require "spec_helper"

RSpec.describe Realms::Cards::BlobDestroyer do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  describe "#cost" do
    subject { card.cost }
    it { is_expected.to eq(4) }
  end

  describe "#primary_ability" do
    before do
      game.start
      card.primary_ability.execute
    end
    it { expect(game.active_turn.combat).to eq(6) }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::BlobWheel.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.decide(:play, :blob_wheel_0)
      game.decide(:play, :blob_destroyer_0)
    end

    it "you may destroy target base and/or and scrap a card in the trade row" do
      game.decide(:ally, :blob_destroyer_0)
      expect(game.current_choice.options.keys).to contain_exactly(:blob_wheel_0, :none)
      game.decide(:blob_wheel_0)
      expect(game.p1.deck.battlefield).to_not include(ally_card)
      expect(game.p1.deck.discard_pile).to include(ally_card)
      expect(game.current_choice.options.keys).to contain_exactly(:scout_0, :none)
      game.decide(:scout_0)
      expect(game.trade_deck.scrap_heap.map(&:key)).to contain_exactly(:scout_0)
    end
  end
end
