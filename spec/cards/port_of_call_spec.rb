require "spec_helper"

RSpec.describe Realms::Cards::PortOfCall do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :outpost
  include_examples "defense", 6
  include_examples "factions", :trade_federation
  include_examples "cost", 6

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.decide(:play, card.key)
    end

    context "authority" do
      it { expect { game.decide(:primary, card.key) }.to change { game.active_turn.trade }.by(3) }
    end
  end

  describe "#scrap_ability" do
    include_examples "destroy_target_base" do
      before do
        game.p1.deck.hand << card
        setup(game)
        game.start
        game.decide(:play, card.key)
        game.decide(:scrap, card.key)
      end
    end
  end
end
