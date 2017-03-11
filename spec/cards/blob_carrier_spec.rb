require "spec_helper"

RSpec.describe Realms::Cards::BlobCarrier do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :blob
  include_examples "cost", 6

  describe "#primary_ability" do
    before do
      game.start
      card.primary_ability.execute
    end
    it { expect(game.active_turn.combat).to eq(7) }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::BlobWheel.new(game.p1) }
    let(:selected_card) { Realms::Cards::BlobDestroyer.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.trade_deck.trade_row[0] = selected_card
      game.start
      game.decide(:play, :blob_wheel_0)
      game.decide(:play, :blob_carrier_0)
    end

    it "acquire any ship without paying its cost and put it on top of your deck" do
      game.decide(:ally, :blob_carrier_0)
      trade_row_cards = game.trade_deck.trade_row.map(&:key)
      expect(game.current_choice.options.keys).to contain_exactly(*trade_row_cards, :none)
      game.decide(:blob_destroyer_0)
      expect(game.trade_deck.trade_row).to_not include(selected_card)
      expect(game.trade_deck.trade_row.length).to eq(5)
      expect(game.p1.deck.draw_pile.first).to eq(selected_card)
      game.p1.draw(1)
      expect(game.p1.deck.hand).to include(selected_card)
    end
  end
end
