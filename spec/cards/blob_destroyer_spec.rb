require "spec_helper"

RSpec.describe Realms::Cards::BlobDestroyer do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :blob
  include_examples "cost", 4

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end
    it { expect { game.play(card) }.to change { game.active_turn.combat }.to eq(6) }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::BlobWheel.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.play(ally_card)
      game.play(card)
    end

    it "you may destroy target base and/or and scrap a card in the trade row" do
      game.ally_ability(card)
      game.decide(:blob_wheel_0)
      expect(game.p1.deck.in_play).to_not include(ally_card)
      expect(game.p1.deck.discard_pile).to include(ally_card)
      trade_row_card = game.trade_deck.trade_row.sample
      game.decide(trade_row_card.key)
      expect(game.trade_deck.scrap_heap).to include(trade_row_card)
    end
  end
end
