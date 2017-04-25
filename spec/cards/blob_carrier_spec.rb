require "spec_helper"

RSpec.describe Realms::Cards::BlobCarrier do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :blob
  include_examples "cost", 6

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end
    it { expect { game.play(card) }.to change { game.active_turn.combat }.by(7) }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::BlobWheel.new(game.p1) }
    let(:selected_card) { Realms::Cards::BlobDestroyer.new(game.p1, index: 10) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.trade_deck.trade_row.cards[0] = selected_card
      game.start
      game.play(ally_card)
      game.play(card)
    end

    it "acquire any ship without paying its cost and put it on top of your deck" do
      game.ally_ability(card)
      game.decide(selected_card.key)
      expect(game.trade_deck.trade_row).to_not include(selected_card)
      expect(game.trade_deck.trade_row.length).to eq(5)
      expect(game.p1.deck.draw_pile.first).to eq(selected_card)
      game.p1.draw(1)
      expect(game.p1.deck.hand).to include(selected_card)
    end
  end
end
