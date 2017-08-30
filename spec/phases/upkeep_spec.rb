require "spec_helper"

RSpec.describe Realms::Phases::Upkeep do
  let(:game) { Realms::Game.new }

  describe "discarding" do
    let(:card) { Realms::Cards::ImperialFighter.new(game.active_player, index: 42) }

    before do
      game.p1.hand << card
      game.start
    end

    it "is resolved once completed" do
      game.play(card)
      game.end_turn

      card_to_discard = game.p2.hand.sample
      game.decide(card_to_discard)
      game.end_turn

      game.end_turn
      game.play(game.p2.hand.sample)
    end
  end
end
