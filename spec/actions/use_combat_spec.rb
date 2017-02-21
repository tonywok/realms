require "spec_helper"

RSpec.describe Realms::Actions::UseCombat do
  let(:game) { Realms::Game.new }

  context "opponent has no bases in play" do
    let(:card) { Realms::Cards::Viper.new(game.p1, index: 0) }

    before do
      game.p1.deck.hand << card
      game.start
    end

    it "deals damage to the opponent" do
      expect {
        game.decide(:play, :viper_0)
      }.to change { game.active_turn.combat }.by(1)

      expect {
        game.decide(:use_combat, game.p2.name.to_sym)
      }.to change { game.p2.authority }.by(-1).and \
           change { game.active_turn.combat }.by(-1)

      expect(game.active_turn.combat).to eq(0)
    end
  end

  xcontext "opponent has a non-output base in play"
  xcontext "opponent has an outpost base in play"
end
