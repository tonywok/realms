require "spec_helper"

RSpec.describe Realms::Cards::RoyalRedoubt do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "type", :outpost
  include_examples "defense", 6
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 6

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.play(card)
    end

    it { expect { game.base_ability(card) }.to change { game.active_turn.combat }.by(3) }
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

    it {
      game.ally_ability(card)
      game.end_turn
      expect {
        game.decide(game.p2.hand.sample.key)
      }.to change { game.p2.hand.length }.by(-1)
    }
  end
end
