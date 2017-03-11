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
        game.decide(:play, card.key)
      }.to change { game.active_turn.combat }.by(6).and \
           change { game.p1.deck.draw_pile.length }.by(-1)
    }
  end

  describe "#ally_ability" do
    before { game.start }
    it {
      expect {
        card.ally_ability.execute
      }.to change { game.p1.deck.hand.length }.by(1)
    }
  end
end
