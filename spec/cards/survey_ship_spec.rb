require "spec_helper"

RSpec.describe Realms::Cards::SurveyShip do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :star_empire
  include_examples "cost", 3

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.trade }.by(1).and \
           change { game.p1.deck.draw_pile.length }.by(-1)
    }
  end

  describe "#scrap_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.play(card)
    end

    it {
      expect {
        game.scrap_ability(card)
        game.end_turn
        game.decide(game.p2.hand.sample.key)
      }.to change { game.p2.hand.length }.by(-1)
    }
  end
end
