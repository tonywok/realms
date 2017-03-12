require "spec_helper"

RSpec.describe Realms::Cards::DefenseCenter do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :outpost
  include_examples "defense", 5
  include_examples "factions", :trade_federation
  include_examples "cost", 5

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.play(card)
      game.base_ability(card)
    end

    context "authority" do
      it { expect { game.decide(:authority) }.to change { game.p1.authority }.by(3) }
    end

    context "combat" do
      it { expect { game.decide(:combat) }.to change { game.active_turn.combat }.by(2) }
    end
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::FederationShuttle.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.play(card)
      game.play(ally_card)
    end

    it { expect { game.ally_ability(card) }.to change { game.active_turn.combat }.by(2) }
  end
end

