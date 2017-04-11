require "spec_helper"

RSpec.describe Realms::Cards::Battlecruiser do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :star_empire
  include_examples "cost", 6

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(5).and \
           change { game.p1.draw_pile.length }.by(-1)
    }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::ImperialFighter.new(game.p1) }

    before do
      game.p1.deck.hand << card
      game.p1.deck.hand << ally_card
      game.start
      game.play(ally_card)
      game.play(card)
    end

    it {
      game.ally_ability(card)
      game.end_turn
      expect {
        game.decide(game.p2.hand.sample.key)
      }.to change { game.p2.hand.length }.by(-1)
    }
  end

  describe "#scrap_ability" do
    include_examples "destroy_target_base" do
      before do
        setup(game)
        game.start
        game.play(card)
        expect {
          game.scrap_ability(card)
        }.to change { game.p1.draw_pile.length }.by(-1)
      end
    end
  end
end
