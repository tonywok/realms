require "spec_helper"

RSpec.describe Realms::Actions::PlayCard do
  let(:game) { Realms::Game.new }

  before do
    cards.each do |card|
      game.active_player.deck.hand << card
    end
    game.start
  end

  context "playing a card" do
    let(:cards) do
      3.times.map { game.active_player.scout }
    end

    it do
      expect {
        game.play(cards[0])
      }.to change { game.active_player.deck.hand.length }.by(-1).and \
           change { game.active_player.deck.in_play.length }.by(1)
      game.play(cards[1])
      game.play(cards[2])
      expect(game.active_turn.trade).to eq(3)
    end
  end

  context "playing a card with an automatically performed ally ability" do
    let(:cards) do
      [
        Realms::Cards::Corvette.new(game.active_player, index: 0),
        Realms::Cards::Corvette.new(game.active_player, index: 1),
      ]
    end

    it do
      expect {
        game.play(:corvette_0)
      }.to change { game.active_turn.combat }.by(1).and \
           change { game.active_player.draw_pile.length }.by(-1)
      expect {
        game.play(:corvette_1)
      }.to change { game.active_turn.combat }.by(5).and \
           change { game.active_player.draw_pile.length }.by(-1)
    end
  end

  context "playing a card with manually performed ally ability" do
    let(:cards) do
      [
        Realms::Cards::BlobFighter.new(game.active_player, index: 0),
        Realms::Cards::BlobFighter.new(game.active_player, index: 1),
      ]
    end

    it do
      expect {
        game.play(:blob_fighter_0)
      }.to change { game.active_turn.combat }.by(3).and \
           change { game.active_player.draw_pile.length }.by(0)
      expect {
        game.play(:blob_fighter_1)
      }.to change { game.active_turn.combat }.by(3).and \
           change { game.active_player.draw_pile.length }.by(0)

      expect {
        game.ally_ability(:blob_fighter_0)
        game.ally_ability(:blob_fighter_1)
      }.to change { game.active_player.draw_pile.length }.by(-2)
    end
  end
end
