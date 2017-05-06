require "spec_helper"

RSpec.describe Realms::Cards::Cutter do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :trade_federation
  include_examples "cost", 2

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.trade }.by(2).and \
           change { game.p1.authority }.by(4)
    }
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

    it { expect { game.ally_ability(card) }.to change { game.active_turn.combat }.by(4) }
  end
end
