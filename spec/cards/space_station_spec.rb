require "spec_helper"

RSpec.describe Realms::Cards::SpaceStation do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :outpost
  include_examples "defense", 4
  include_examples "factions", :star_empire
  include_examples "cost", 4

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.play(card)
    end

    it { expect { game.base_ability(card) }.to change { game.active_turn.combat }.by(2) }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::SurveyShip.new(game.p1) }
    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.play(card)
      game.play(ally_card)
    end
    it { expect { game.ally_ability(card) }.to change { game.active_turn.combat }.by(2) }
  end

  describe "#scrap_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.play(card)
    end
    it { expect { game.scrap_ability(card) }.to change { game.active_turn.trade }.by(4) }
  end
end
