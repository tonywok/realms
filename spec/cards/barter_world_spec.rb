require "spec_helper"

RSpec.describe Realms::Cards::BarterWorld do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :base
  include_examples "defense", 4
  include_examples "factions", :trade_federation
  include_examples "cost", 4

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.play(card)
      game.base_ability(card)
    end

    context "authority" do
      it { expect { game.decide(:authority) }.to change { game.p1.authority }.by(2) }
    end

    context "trade" do
      it { expect { game.decide(:trade) }.to change { game.active_turn.trade }.by(2) }
    end
  end

  describe "#scrap_ability" do
    let(:ally_card) { Realms::Cards::FederationShuttle.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.play(card)
      game.play(ally_card)
    end

    it { expect { game.scrap_ability(card) }.to change { game.active_turn.combat }.by(5) }
  end
end
