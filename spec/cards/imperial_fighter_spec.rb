require "spec_helper"

RSpec.describe Realms::Cards::ImperialFighter do
  include_examples "factions", Realms::Cards::Card::Factions::STAR_ALLIANCE
  include_examples "cost", 1

  describe "#primary_ability" do
    include_context "primary_ability"

    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(2)
      game.end_turn
      expect {
        game.discard(game.active_player.hand.sample)
      }.to change { game.active_player.hand.length }.by(-1)
    }
  end

  describe "#ally_ability" do
    include_context "automatic_ally_ability", Realms::Cards::ImperialFighter
    it { expect { game.play(card) }.to change { game.active_turn.combat }.by(6) }
  end
end
