require "spec_helper"

RSpec.describe Realms::Cards::CommandShip do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :trade_federation
  include_examples "cost", 8

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end

    it {
      expect {
        game.decide(:play, card.key)
      }.to change { game.p1.authority }.by(4).and \
           change { game.p1.active_turn.combat }.by(5).and \
           change { game.p1.deck.draw_pile.length }.by(-2)
    }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::FederationShuttle.new(game.p1) }

    include_examples "destroy_target_base" do
      before do
        game.p1.deck.hand << ally_card
        setup(game)
        game.start
        game.decide(:play, ally_card.key)
        game.decide(:play, card.key)
        game.decide(:ally, card.key)
      end
    end
  end
end
