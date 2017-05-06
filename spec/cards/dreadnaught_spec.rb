require "spec_helper"

RSpec.describe Realms::Cards::Dreadnaught do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 7

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(7).and \
           change { game.p1.draw_pile.length }.by(-1)
    }
  end

  describe "#scrap_ability" do
    before do
      game.p1.deck.hand << card
      game.start
      game.play(card)
    end
    it { expect { game.scrap_ability(card) }.to change { game.active_turn.combat }.by(5) }
  end
end
