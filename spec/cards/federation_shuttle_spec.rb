require "spec_helper"

RSpec.describe Realms::Cards::FederationShuttle do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :trade_federation
  include_examples "cost", 1

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.trade }.by(2)
    }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::Cutter.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.play(ally_card)
      game.play(card)
    end

    it {
      expect {
        game.ally_ability(card)
      }.to change { game.p1.authority }.by(4)
    }
  end
end
