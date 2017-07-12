require "spec_helper"

RSpec.describe Realms::Cards::Mothership do
  let(:game) { Realms::Game.new }
  let(:card) { described_class.new(game.active_player) }

  include_examples "factions", :blob
  include_examples "cost", 7

  describe "#primary_ability" do
    before do
      game.active_player.deck.hand << card
      game.start
    end

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(6).and \
           change { game.active_player.deck.draw_pile.length }.by(-1)
    }
  end

  describe "#ally_ability" do
    let(:ally_card) { Realms::Cards::BlobFighter.new(game.active_player) }

    before do
      game.active_player.deck.hand << ally_card
      game.active_player.deck.hand << card
      game.start
      game.play(ally_card)
      game.play(card)
    end

    it { expect { game.ally_ability(card) }.to change { game.active_player.deck.hand.length }.by(1) }
  end
end
