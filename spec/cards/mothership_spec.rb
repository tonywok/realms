require "spec_helper"

RSpec.describe Realms::Cards::Mothership do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.p1) }

  include_examples "factions", :blob
  include_examples "cost", 7

  describe "#primary_ability" do
    before do
      game.p1.deck.hand << card
      game.start
    end

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(6).and \
           change { game.p1.deck.draw_pile.length }.by(-1)
    }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::BlobFighter.new(game.p1) }

    before do
      game.p1.deck.hand << ally_card
      game.p1.deck.hand << card
      game.start
      game.play(ally_card)
      game.play(card)
    end

    it { expect { game.ally_ability(card) }.to change { game.p1.deck.hand.length }.by(1) }
  end
end
