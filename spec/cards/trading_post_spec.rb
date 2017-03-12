require "spec_helper"

RSpec.describe Realms::Cards::TradingPost do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :outpost
  include_examples "defense", 4
  include_examples "factions", :trade_federation
  include_examples "cost", 3

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.play(card)
      game.base_ability(card)
    end

    context "authority" do
      it { expect { game.decide(:authority) }.to change { game.p1.authority }.by(1) }
    end

    context "trade" do
      it { expect { game.decide(:trade) }.to change { game.active_turn.trade }.by(1) }
    end
  end

  describe "#scrap_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.play(card)
    end

    it { expect { game.scrap_ability(card) }.to change { game.active_turn.combat }.by(3) }
  end
end
