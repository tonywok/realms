require "spec_helper"

RSpec.describe Realms::Cards::BlobFighter do
  include_examples "factions", :blob
  include_examples "cost", 1

  describe "#primary_ability" do
    include_context "primary_ability"
    it {
      expect {
        game.play(card)
      }.to change { game.active_turn.combat }.by(3)
    }
  end

  describe "#ally_ability" do
    include_context "ally_ability", Realms::Cards::TradePod
    it {
      expect {
        game.ally_ability(card)
      }.to change { game.p1.hand.length }.by(1)
    }
  end
end
